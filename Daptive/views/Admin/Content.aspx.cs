using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Daptive.Admin
{
    public partial class Content : Page
    {
        private readonly string _connStr = System.Configuration.ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
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
                PopulateQuestionDropDown();
            }
        }
        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/views/authentication/Login.aspx");
        }
        private void LoadQuestions()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string sql = @"SELECT q.QuizId AS QuestionId, CAST(q.Quiz AS nvarchar(500)) AS Question, COUNT(t.TestCaseId) AS TestCaseCount FROM [quiz] q LEFT JOIN [testcase] t ON q.QuizId = t.QuizId GROUP BY q.QuizId, CAST(q.Quiz AS nvarchar(500)) ORDER BY q.QuizId DESC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    litQuestionCount.Text = dt.Rows.Count.ToString();
                    lblNoQuestions.Visible = dt.Rows.Count == 0;
                    rptQuestions.Visible = dt.Rows.Count > 0;
                    if (dt.Rows.Count > 0)
                    {
                        rptQuestions.DataSource = dt;
                        rptQuestions.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load questions: " + ex.Message);
            }
        }
        private void LoadTestCases()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string sql = @"SELECT t.TestCaseId, t.QuizId, t.TestCase, t.ExpectedResult, CAST(q.Quiz AS nvarchar(500)) AS QuestionText FROM [testcase] t LEFT JOIN [quiz] q ON t.QuizId = q.QuizId ORDER BY t.QuizId, t.TestCaseId";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    litTestCaseCount.Text = dt.Rows.Count.ToString();
                    lblNoTestCases.Visible = dt.Rows.Count == 0;
                    rptTestCases.Visible = dt.Rows.Count > 0;
                    if (dt.Rows.Count > 0)
                    {
                        rptTestCases.DataSource = dt;
                        rptTestCases.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load test cases: " + ex.Message);
            }
        }
        private void PopulateQuestionDropDown()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string sql = "SELECT QuizId, CAST(Quiz AS nvarchar(500)) AS Quiz FROM [quiz] ORDER BY QuizId DESC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    ddlTestCaseQuestion.Items.Clear();
                    ddlTestCaseQuestion.Items.Add(new ListItem("-- Select a question --", ""));
                    foreach (DataRow row in dt.Rows)
                    {
                        string label = row["Quiz"].ToString();
                        if (label.Length > 80)
                        {
                            label = label.Substring(0, 77) + "…";
                        }
                        ddlTestCaseQuestion.Items.Add(new ListItem(label, row["QuizId"].ToString()));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load questions for dropdown: " + ex.Message);
            }
        }
        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            string questionText = txtQuestion.Text.Trim();
            if (string.IsNullOrEmpty(questionText))
            {
                ShowError("Question text is required.");
                return;
            }
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string sql = "INSERT INTO [quiz] (Quiz) VALUES (@Quiz)";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Quiz", questionText);
                        cmd.ExecuteNonQuery();
                    }
                }
                txtQuestion.Text = "";
                ShowSuccess("Question added successfully.");
                LoadQuestions();
                LoadTestCases();
                PopulateQuestionDropDown();
            }
            catch (Exception ex)
            {
                ShowError("Could not add question: " + ex.Message);
            }
        }
        protected void btnAddTestCase_Click(object sender, EventArgs e)
        {
            string questionVal = ddlTestCaseQuestion.SelectedValue;
            string testCase = txtTestCase.Text.Trim();
            string expectedResult = txtExpectedResult.Text.Trim();
            if (string.IsNullOrEmpty(questionVal))
            {
                ShowError("Please select a question for this test case.");
                return;
            }
            if (string.IsNullOrEmpty(testCase))
            {
                ShowError("Test case input is required.");
                return;
            }
            if (string.IsNullOrEmpty(expectedResult))
            {
                ShowError("Expected output is required.");
                return;
            }
            int questionId = Convert.ToInt32(questionVal);
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string sql = @"INSERT INTO [testcase] (QuizId, TestCase, ExpectedResult) VALUES (@QuizId, @TestCase, @ExpectedResult)";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", questionId);
                        cmd.Parameters.AddWithValue("@TestCase", testCase);
                        cmd.Parameters.AddWithValue("@ExpectedResult", expectedResult);
                        cmd.ExecuteNonQuery();
                    }
                }
                txtTestCase.Text = "";
                txtExpectedResult.Text = "";
                ShowSuccess("Test case added successfully.");
                LoadQuestions();
                LoadTestCases();
                PopulateQuestionDropDown();
            }
            catch (Exception ex)
            {
                ShowError("Could not add test case: " + ex.Message);
            }
        }
        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteQuestion") return;
            int questionID = Convert.ToInt32(e.CommandArgument);
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string deleteScores = "DELETE FROM [score] WHERE QuizId = @QuizId";
                    using (SqlCommand cmd = new SqlCommand(deleteScores, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", questionID);
                        cmd.ExecuteNonQuery();
                    }
                    const string deleteTestCases = "DELETE FROM [testcase] WHERE QuizId = @QuizId";
                    using (SqlCommand cmd2 = new SqlCommand(deleteTestCases, conn))
                    {
                        cmd2.Parameters.AddWithValue("@QuizId", questionID);
                        cmd2.ExecuteNonQuery();
                    }
                    const string deleteQuestion = "DELETE FROM [quiz] WHERE QuizId = @QuizId";
                    using (SqlCommand cmd3 = new SqlCommand(deleteQuestion, conn))
                    {
                        cmd3.Parameters.AddWithValue("@QuizId", questionID);
                        cmd3.ExecuteNonQuery();
                    }
                }
                ShowSuccess("Question and its test cases deleted successfully.");
                LoadQuestions();
                LoadTestCases();
                PopulateQuestionDropDown();
            }
            catch (Exception ex)
            {
                ShowError("Could not delete question: " + ex.Message);
            }
        }
        protected void rptTestCases_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteTestCase")
            {
                return;
            }
            int testCaseID = Convert.ToInt32(e.CommandArgument);
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string sql ="DELETE FROM [testcase] WHERE TestCaseId = @TestCaseId";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@TestCaseId", testCaseID);
                        cmd.ExecuteNonQuery();
                    }
                }
                ShowSuccess("Test case deleted successfully.");
                LoadQuestions();
                LoadTestCases();
                PopulateQuestionDropDown();
            }
            catch (Exception ex)
            {
                ShowError("Could not delete test case: " + ex.Message);
            }
        }
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
            if (string.IsNullOrWhiteSpace(name))
            {
                return "??";
            }
            string[] parts = name.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1)
            {
                return parts[0].Substring(0, Math.Min(2, parts[0].Length)).ToUpper();
            }
            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper();
        }
    }
}   