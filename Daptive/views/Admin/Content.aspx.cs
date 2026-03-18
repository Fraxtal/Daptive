using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Daptive.Admin
{
    public partial class Content : Page
    {
        private readonly string _connStr =
            System.Configuration.ConfigurationManager
                  .ConnectionStrings["CodeDaptiveDB"].ConnectionString;

        // ── Page Load ─────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Role"] == null || Session["Role"].ToString().ToLower() != "admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string username = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
                litUsername.Text = username;
                litInitials.Text = GetInitials(username);

                LoadQuestions();
                LoadTestCases();
            }
        }

        // ── Load Questions ────────────────────────────────────────────
        private void LoadQuestions()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    string sql = @"
                        SELECT q.QuestionId,
                               q.Question,
                               COUNT(t.TestCaseId) AS TestCaseCount
                        FROM   [question] q
                        LEFT JOIN [testcase] t ON q.QuestionId = t.QuestionId
                        GROUP BY q.QuestionId, q.Question
                        ORDER BY q.QuestionId DESC";

                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                        da.Fill(dt);

                    litQuestionCount.Text = dt.Rows.Count.ToString();

                    if (dt.Rows.Count == 0)
                    {
                        lblNoQuestions.Visible = true;
                        rptQuestions.Visible = false;
                        return;
                    }

                    lblNoQuestions.Visible = false;
                    rptQuestions.Visible = true;
                    rptQuestions.DataSource = dt;
                    rptQuestions.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load questions: " + ex.Message);
            }
        }

        // ── Load Test Cases ───────────────────────────────────────────
        private void LoadTestCases()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    string sql = @"
                        SELECT t.TestCaseId,
                               t.QuestionId,
                               t.TestCase,
                               t.ExpectedResult,
                               q.Question AS QuestionText
                        FROM   [testcase] t
                        LEFT JOIN [question] q ON t.QuestionId = q.QuestionId
                        ORDER BY t.QuestionId, t.TestCaseId";

                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                        da.Fill(dt);

                    litTestCaseCount.Text = dt.Rows.Count.ToString();

                    if (dt.Rows.Count == 0)
                    {
                        lblNoTestCases.Visible = true;
                        rptTestCases.Visible = false;
                        return;
                    }

                    lblNoTestCases.Visible = false;
                    rptTestCases.Visible = true;
                    rptTestCases.DataSource = dt;
                    rptTestCases.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load test cases: " + ex.Message);
            }
        }

        // ── Question Repeater Command ─────────────────────────────────
        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteQuestion") return;

            int questionID = Convert.ToInt32(e.CommandArgument);

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    // Delete related scores first
                    string deleteScores = "DELETE FROM [score] WHERE QuestionId = @QuestionId";
                    using (SqlCommand cmd = new SqlCommand(deleteScores, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuestionId", questionID);
                        cmd.ExecuteNonQuery();
                    }

                    // Delete related test cases
                    string deleteTestCases = "DELETE FROM [testcase] WHERE QuestionId = @QuestionId";
                    using (SqlCommand cmd2 = new SqlCommand(deleteTestCases, conn))
                    {
                        cmd2.Parameters.AddWithValue("@QuestionId", questionID);
                        cmd2.ExecuteNonQuery();
                    }

                    // Delete the question itself
                    string deleteQuestion = "DELETE FROM [question] WHERE QuestionId = @QuestionId";
                    using (SqlCommand cmd3 = new SqlCommand(deleteQuestion, conn))
                    {
                        cmd3.Parameters.AddWithValue("@QuestionId", questionID);
                        cmd3.ExecuteNonQuery();
                    }
                }

                ShowSuccess("Question and its test cases deleted successfully.");
                LoadQuestions();
                LoadTestCases();
            }
            catch (Exception ex)
            {
                ShowError("Could not delete question: " + ex.Message);
            }
        }

        // ── Test Case Repeater Command ────────────────────────────────
        protected void rptTestCases_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteTestCase") return;

            int testCaseID = Convert.ToInt32(e.CommandArgument);

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    string sql = "DELETE FROM [testcase] WHERE TestCaseId = @TestCaseId";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@TestCaseId", testCaseID);
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowSuccess("Test case deleted successfully.");
                LoadQuestions();
                LoadTestCases();
            }
            catch (Exception ex)
            {
                ShowError("Could not delete test case: " + ex.Message);
            }
        }

        // ── Helpers ───────────────────────────────────────────────────
        private void ShowSuccess(string msg)
        {
            lblSuccess.Text = msg;
            lblSuccess.Visible = true;
            lblError.Visible = false;
        }

        private void ShowError(string msg)
        {
            lblError.Text = msg;
            lblError.Visible = true;
            lblSuccess.Visible = false;
        }

        private static string GetInitials(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "??";
            string[] parts = name.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1)
                return parts[0].Substring(0, Math.Min(2, parts[0].Length)).ToUpper();
            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper();
        }
    }
}