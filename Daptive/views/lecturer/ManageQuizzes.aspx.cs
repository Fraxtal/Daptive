using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Collections;
using System.Web.UI;

namespace Daptive.views.lecturer
{
    public partial class ManageQuizzes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindQuizzes();
            }
        }
        protected void btnsignout_click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/views/authentication/Login.aspx");
        }

        protected void btnModalSavePost_Click(object sender, EventArgs e)
        {
            int id;
            if (!int.TryParse(hfModalQuizId.Value, out id)) return;
            var name = hfModalQuizName.Value ?? string.Empty;
            var desc = hfModalQuizContent.Value ?? hfModalQuizDesc.Value ?? string.Empty;
            // parse testcases JSON
            object[] tests = null;
            try {
                var json = hfModalTestCases.Value ?? "[]";
                var serializer = new JavaScriptSerializer();
                var list = serializer.Deserialize<System.Collections.Generic.List<System.Collections.Generic.Dictionary<string,string>>>(json);
                if (list != null)
                {
                    var htList = new ArrayList();
                    foreach (var dict in list)
                    {
                        var ht = new Hashtable();
                        if (dict.ContainsKey("Input")) ht["Input"] = dict["Input"];
                        if (dict.ContainsKey("Expected")) ht["Expected"] = dict["Expected"];
                        htList.Add(ht);
                    }
                    tests = htList.ToArray();
                }
            } catch { tests = null; }

            // call SaveQuizChanges WebMethod logic directly
            SaveQuizChanges(id, name, desc, tests);
            // optionally rebind
            BindQuizzes();
        }

        protected void btnConfirmDeletePost_Click(object sender, EventArgs e)
        {
            int id;
            if (!int.TryParse(hfDeleteQuizId.Value, out id)) return;
            DeleteQuiz(id);
            BindQuizzes();
        }


        [System.Web.Services.WebMethod]
        public static object GetQuiz(int quizId)
        {
            try
            {
                var connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand("SELECT QuizId, Quiz, Description FROM [dbo].[quiz] WHERE QuizId = @id", conn))
                {
                    cmd.Parameters.Add(new SqlParameter("@id", System.Data.SqlDbType.Int) { Value = quizId });
                    conn.Open();
                    using (var rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            var quizIdVal = rdr.GetInt32(0);
                            var quizName = rdr.IsDBNull(1) ? string.Empty : rdr.GetString(1);
                            var quizDesc = rdr.IsDBNull(2) ? string.Empty : rdr.GetString(2);
                            rdr.Close();

                            // load test cases after closing the first reader
                            var tests = new System.Collections.Generic.List<object>();
                            using (var cmd2 = new SqlCommand("SELECT TestCase, ExpectedResult FROM [dbo].[testcase] WHERE QuizId = @id", conn))
                            {
                                cmd2.Parameters.Add(new SqlParameter("@id", System.Data.SqlDbType.Int) { Value = quizIdVal });
                                using (var rdr2 = cmd2.ExecuteReader())
                                {
                                    while (rdr2.Read())
                                    {
                                        tests.Add(new { TestCase = rdr2.IsDBNull(0) ? string.Empty : rdr2.GetString(0), ExpectedResult = rdr2.IsDBNull(1) ? string.Empty : rdr2.GetString(1) });
                                    }
                                }
                            }

                            return new { Quiz = quizName, Description = quizDesc, TestCases = tests };
                        }
                    }
                }

                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        
        [System.Web.Services.WebMethod]
        public static object SaveQuizChanges(int quizId, string quiz, string description, object[] testcases)
        {
            try
            {
                var connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    using (var tran = conn.BeginTransaction())
                    {
                        try
                        {
                            using (var cmd = new SqlCommand("UPDATE [dbo].[quiz] SET Quiz = @Quiz, Description = @Desc WHERE QuizId = @Id", conn, tran))
                            {
                                cmd.Parameters.Add(new SqlParameter("@Quiz", System.Data.SqlDbType.NVarChar, 255) { Value = quiz ?? string.Empty });
                                cmd.Parameters.Add(new SqlParameter("@Desc", System.Data.SqlDbType.Text) { Value = description ?? string.Empty });
                                cmd.Parameters.Add(new SqlParameter("@Id", System.Data.SqlDbType.Int) { Value = quizId });
                                cmd.ExecuteNonQuery();
                            }

                            // delete existing tests and re-insert
                            using (var cmdDel = new SqlCommand("DELETE FROM [dbo].[testcase] WHERE QuizId = @Id", conn, tran))
                            {
                                cmdDel.Parameters.Add(new SqlParameter("@Id", System.Data.SqlDbType.Int) { Value = quizId });
                                cmdDel.ExecuteNonQuery();
                            }

                            if (testcases != null)
                            {
                                foreach (var t in testcases)
                                {
                                    var dict = t as System.Collections.IDictionary;
                                    string input = string.Empty, expected = string.Empty;
                                    if (dict != null)
                                    {
                                        if (dict.Contains("Input")) input = dict["Input"]?.ToString() ?? string.Empty;
                                        if (dict.Contains("Expected")) expected = dict["Expected"]?.ToString() ?? string.Empty;
                                    }

                                    using (var cmdIns = new SqlCommand("INSERT INTO [dbo].[testcase] (QuizId, TestCase, ExpectedResult) VALUES (@QuizId, @Tc, @Er)", conn, tran))
                                    {
                                        cmdIns.Parameters.Add(new SqlParameter("@QuizId", System.Data.SqlDbType.Int) { Value = quizId });
                                        cmdIns.Parameters.Add(new SqlParameter("@Tc", System.Data.SqlDbType.Text) { Value = input });
                                        cmdIns.Parameters.Add(new SqlParameter("@Er", System.Data.SqlDbType.Text) { Value = expected });
                                        cmdIns.ExecuteNonQuery();
                                    }
                                }
                            }

                            tran.Commit();
                            return new { success = true };
                        }
                        catch
                        {
                            tran.Rollback();
                            return new { success = false };
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return new { success = false };
            }
        }

        private void BindQuizzes()
        {
            var connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand("SELECT QuizId, Quiz, Description FROM [dbo].[quiz] ORDER BY QuizId DESC", conn))
            using (var da = new SqlDataAdapter(cmd))
            {
                var dt = new DataTable();
                da.Fill(dt);
                gvQuizzes.DataSource = dt;
                gvQuizzes.DataBind();
            }
        }


        [System.Web.Services.WebMethod]
        public static object DeleteQuiz(int quizId)
        {
            try
            {
                var connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
                using (var conn = new SqlConnection(connStr))
                using (var cmd = new SqlCommand("DELETE FROM [dbo].[testcase] WHERE QuizId = @QuizId; DELETE FROM [dbo].[quiz] WHERE QuizId = @QuizId;", conn))
                {
                    cmd.Parameters.Add(new SqlParameter("@QuizId", System.Data.SqlDbType.Int) { Value = quizId });
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                return new { success = true };
            }
            catch (Exception ex)
            {
                return new { success = false, error = ex.Message };
            }
        }
    }
}
