using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Daptive.views.Admin
{
    public partial class Reports : Page
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
                LoadScores();
                LoadUsers();
                LoadCourses();
                LoadQuestions();
            }
        }
        private void LoadScores()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"SELECT s.ScoreId, s.Score, u.FullName, u.Username, q.Question FROM [score] s LEFT JOIN [user] u ON s.UserId = u.UserID LEFT JOIN [question] q ON s.QuestionId = q.QuestionId ORDER BY s.ScoreId DESC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    litScoreCount.Text = dt.Rows.Count.ToString();
                    if (dt.Rows.Count == 0)
                    {
                        lblNoScores.Visible = true;
                        rptScores.Visible = false;
                        return;
                    }
                    dt.Columns.Add("ScoreClass", typeof(string));
                    foreach (DataRow row in dt.Rows)
                    {
                        int score = row["Score"] != DBNull.Value ? Convert.ToInt32(row["Score"]) : 0;
                        if (score >= 80)
                        {
                            row["ScoreClass"] = "score-high";
                        }
                        else if (score >= 50)
                        {
                            row["ScoreClass"] = "score-mid";
                        }
                        else
                        {
                            row["ScoreClass"] = "score-low";
                        }
                    }
                    lblNoScores.Visible = false;
                    rptScores.Visible = true;
                    rptScores.DataSource = dt;
                    rptScores.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadScores error: " + ex.Message);
            }
        }
        private void LoadUsers()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"SELECT UserID, FullName, Username, Email, Role FROM [user] ORDER BY UserID ASC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    litUserCount.Text = dt.Rows.Count.ToString();
                    if (dt.Rows.Count == 0)
                    {
                        lblNoUsers.Visible = true;
                        rptUsers.Visible = false;
                        return;
                    }
                    dt.Columns.Add("BadgeClass", typeof(string));
                    foreach (DataRow row in dt.Rows)
                    {
                        string role = row["Role"] != null ? row["Role"].ToString() : "Student";
                        row["BadgeClass"] = GetRoleBadgeClass(role);
                    }
                    lblNoUsers.Visible = false;
                    rptUsers.Visible = true;
                    rptUsers.DataSource = dt;
                    rptUsers.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUsers error: " + ex.Message);
            }
        }
        private void LoadCourses()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"SELECT c.CourseId, c.Name, c.Content, ISNULL(t.Topic, 'No Topic') AS TopicName FROM [course] c LEFT JOIN [topic] t ON c.TopicId = t.TopicId ORDER BY t.Topic, c.Name";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    litCourseCount.Text = dt.Rows.Count.ToString();
                    if (dt.Rows.Count == 0)
                    {
                        lblNoCourses.Visible = true;
                        rptCourses.Visible = false;
                        return;
                    }
                    lblNoCourses.Visible = false;
                    rptCourses.Visible = true;
                    rptCourses.DataSource = dt;
                    rptCourses.DataBind();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadCourses error: " + ex.Message);
            }
        }
        private void LoadQuestions()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"SELECT q.QuestionId, q.Question, COUNT(t.TestCaseId) AS TestCaseCount FROM [question] q LEFT JOIN [testcase] t ON q.QuestionId = t.QuestionId GROUP BY q.QuestionId, q.Question ORDER BY q.QuestionId ASC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }                
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
                System.Diagnostics.Debug.WriteLine("LoadQuestions error: " + ex.Message);
            }
        }
        private static string GetRoleBadgeClass(string role)
        {
            switch (role.ToLower())
            {
                case "lecturer":
                    return "b-lecturer";
                case "admin":
                    return "b-admin";
                default:
                    return "b-student";
            }
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
