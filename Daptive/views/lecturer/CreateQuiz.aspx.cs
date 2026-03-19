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
        protected void btnsignout_click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/views/authentication/Login.aspx");
        }
        protected void SaveQuiz_Click(object sender, EventArgs e)
        {
            string name = txtQuizName.Text.Trim();
            string description = txtQuizContent.Text.Trim();
            string testcasesJson = hfTestCases.Value; // expected as 'tc::expected||tc::expected'

            if (string.IsNullOrEmpty(name))
            {
                Response.Write("<script>alert('Please enter a quiz name.');</script>");
                return;
            }
            if (string.IsNullOrEmpty(description))
            {
                Response.Write("<script>alert('Please provide a problem statement/description.');</script>");
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
                        // Insert quiz (schema: [dbo].[quiz] ([QuizId], [Quiz], [Description]))
                        int quizId;
                        using (var cmd = new SqlCommand("INSERT INTO [dbo].[quiz] ([Quiz], [Description]) OUTPUT INSERTED.[QuizId] VALUES (@Quiz, @Description)", conn, tran))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Quiz", System.Data.SqlDbType.NVarChar, 255) { Value = name });
                            cmd.Parameters.Add(new SqlParameter("@Description", System.Data.SqlDbType.Text) { Value = string.IsNullOrEmpty(description) ? (object)DBNull.Value : description });
                            quizId = (int)cmd.ExecuteScalar();
                        }

                        // Insert quiz content into course or appropriate table - assuming course table has fields: QuizId, Content, DefaultCode -> but per schema there is a course table with QuizId
                        // If there is a `course` table separate, skip. Here we will insert into `testcase` table based on provided testcases

                        // Parse testcasesJson (format produced by client: tc::expected||tc::expected||...)
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
                                    testcases.Add(Tuple.Create(parts[0].Trim(), parts[1].Trim()));
                            }
                        }

                        if (testcases.Count < 1)
                        {
                            Response.Write("<script>alert('Please add at least one test case.');</script>");
                            tran.Rollback();
                            return;
                        }

                        foreach (var tc in testcases)
                        {
                            using (var cmd = new SqlCommand("INSERT INTO [dbo].[testcase] ([QuizId], [TestCase], [ExpectedResult]) VALUES (@QuizId, @TestCase, @Expected)", conn, tran))
                            {
                                cmd.Parameters.Add(new SqlParameter("@QuizId", System.Data.SqlDbType.Int) { Value = quizId });
                                // TestCase and ExpectedResult are TEXT in schema - use SqlDbType.Text
                                cmd.Parameters.Add(new SqlParameter("@TestCase", System.Data.SqlDbType.Text) { Value = tc.Item1 });
                                cmd.Parameters.Add(new SqlParameter("@Expected", System.Data.SqlDbType.Text) { Value = tc.Item2 });
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