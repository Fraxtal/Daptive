using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Daptive.Admin
{
    public partial class Courses : Page
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
                LoadCourses();
                LoadTopics();
            }
        }
        private void LoadCourses()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"SELECT c.CourseId, c.Name, c.Content, c.DefaultCode, ISNULL(t.Topic, 'No Topic') AS TopicName FROM [course] c LEFT JOIN [topic] t ON c.TopicId = t.TopicId ORDER BY c.CourseId DESC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    litCourseCount.Text = dt.Rows.Count.ToString();
                    if (dt.Rows.Count == 0)
                    {
                        lblNoCourses.Visible = true;
                        rptCourses.Visible   = false;
                        return;
                    }
                    lblNoCourses.Visible  = false;
                    rptCourses.Visible    = true;
                    rptCourses.DataSource = dt;
                    rptCourses.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load courses: " + ex.Message);
            }
        }
        private void LoadTopics()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"SELECT t.TopicId, t.Topic, t.Description, COUNT(c.CourseId) AS CourseCount FROM [topic] t LEFT JOIN [course] c ON t.TopicId = c.TopicId GROUP BY t.TopicId, t.Topic, t.Description ORDER BY t.TopicId DESC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    litTopicCount.Text = dt.Rows.Count.ToString();
                    if (dt.Rows.Count == 0)
                    {
                        lblNoTopics.Visible = true;
                        rptTopics.Visible   = false;
                        return;
                    }
                    lblNoTopics.Visible  = false;
                    rptTopics.Visible    = true;
                    rptTopics.DataSource = dt;
                    rptTopics.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load topics: " + ex.Message);
            }
        }
        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteCourse")
            {
                return;
            }
            int courseID = Convert.ToInt32(e.CommandArgument);
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string deleteScores = @"DELETE FROM [score] WHERE QuestionId IN (SELECT QuestionId FROM [question] WHERE QuestionId = @CourseId)";
                    using (SqlCommand cmd = new SqlCommand(deleteScores, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseID);
                        cmd.ExecuteNonQuery();
                    }
                    string deleteCourse = "DELETE FROM [course] WHERE CourseId = @CourseId";
                    using (SqlCommand cmd2 = new SqlCommand(deleteCourse, conn))
                    {
                        cmd2.Parameters.AddWithValue("@CourseId", courseID);
                        cmd2.ExecuteNonQuery();
                    }
                }
                ShowSuccess("Course deleted successfully.");
                LoadCourses();
                LoadTopics();
            }
            catch (Exception ex)
            {
                ShowError("Could not delete course: " + ex.Message);
            }
        }
        protected void rptTopics_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteTopic")
            {
                return;
            }
            int topicID = Convert.ToInt32(e.CommandArgument);
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string unlinkCourses = "UPDATE [course] SET TopicId = NULL WHERE TopicId = @TopicId";
                    using (SqlCommand cmd = new SqlCommand(unlinkCourses, conn))
                    {
                        cmd.Parameters.AddWithValue("@TopicId", topicID);
                        cmd.ExecuteNonQuery();
                    }
                    string deleteTopic = "DELETE FROM [topic] WHERE TopicId = @TopicId";
                    using (SqlCommand cmd2 = new SqlCommand(deleteTopic, conn))
                    {
                        cmd2.Parameters.AddWithValue("@TopicId", topicID);
                        cmd2.ExecuteNonQuery();
                    }
                }
                ShowSuccess("Topic deleted successfully.");
                LoadCourses();
                LoadTopics();
            }
            catch (Exception ex)
            {
                ShowError("Could not delete topic: " + ex.Message);
            }
        }
        private void ShowSuccess(string msg)
        {
            lblSuccess.Text    = msg;
            lblSuccess.Visible = true;
            lblError.Visible   = false;
        }
        private void ShowError(string msg)
        {
            lblError.Text      = msg;
            lblError.Visible   = true;
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