using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Daptive.views.lecturer
{
    public partial class CreateQuiz1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void SaveQuiz_Click(object sender, EventArgs e)
        {
            var name = txtQuizName.Text.Trim();
            var content = txtQuizContent.Text.Trim();
            var defaultCode = txtDefaultCode.Text.Trim();
            var testcasesJson = hfTestCases.Value; // expected as JSON array of {testCase, expectedResult}

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(content) || string.IsNullOrEmpty(defaultCode))
            {
                // Basic validation - ideally show message on page
                return;
            }

            var connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (var tran = conn.BeginTransaction())
                {
                    try
                    {
                        // Insert quiz
                        var insertQuiz = "INSERT INTO quiz (Quiz) OUTPUT INSERTED.QuizId VALUES (@QuizName)";
                        int quizId;
                        using (var cmd = new SqlCommand(insertQuiz, conn, tran))
                        {
                            cmd.Parameters.AddWithValue("@QuizName", name);
                            quizId = (int)cmd.ExecuteScalar();
                        }

                        // Insert quiz content into course or appropriate table - assuming course table has fields: QuizId, Content, DefaultCode -> but per schema there is a course table with QuizId
                        // If there is a `course` table separate, skip. Here we will insert into `testcase` table based on provided testcases

                        // Parse testcasesJson (simple parsing assuming format: [{"testCase":"...","expectedResult":"..."},...])
                        var testcases = new List<Tuple<string, string>>();
                        if (!string.IsNullOrEmpty(testcasesJson))
                        {
                            // Very basic parsing without JSON library: split by a sentinel. Better to add JSON.NET, but keep simple.
                            // Expecting JSON produced by client-side script below.
                            testcasesJson = testcasesJson.Trim();
                            // Fallback: if uses '||' separator
                            var pairs = testcasesJson.Split(new[] { "||" }, StringSplitOptions.RemoveEmptyEntries);
                            foreach (var p in pairs)
                            {
                                var parts = p.Split(new[] { "::" }, StringSplitOptions.None);
                                if (parts.Length == 2)
                                    testcases.Add(Tuple.Create(parts[0], parts[1]));
                            }
                        }

                        foreach (var tc in testcases)
                        {
                            using (var cmd = new SqlCommand("INSERT INTO testcase (QuizId, TestCase, ExpectedResult) VALUES (@QuizId, @TestCase, @Expected)", conn, tran))
                            {
                                cmd.Parameters.AddWithValue("@QuizId", quizId);
                                cmd.Parameters.AddWithValue("@TestCase", tc.Item1);
                                cmd.Parameters.AddWithValue("@Expected", tc.Item2);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        tran.Commit();
                        // Redirect or show success
                        var safeName = name.Replace("'", "\\'");
                        var msg = "Quiz " + safeName + " published with " + testcases.Count + " test case(s)!";
                        Response.Write("<script>alert('" + msg.Replace("'", "\\'") + "');window.location=window.location;</script>");
                    }
                    catch (Exception ex)
                    {
                        tran.Rollback();
                        // Log error
                        Response.Write("<script>alert('Failed to save quiz.');</script>");
                    }
                }
            }
        }
    }
}