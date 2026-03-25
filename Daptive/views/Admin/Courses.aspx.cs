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
                PopulateTopicDropDown();
            }
        }
        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/views/authentication/Login.aspx");
        }
        private void LoadCourses()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string sql = @"SELECT c.CourseId, c.Name, c.Content, c.DefaultCode, ISNULL(t.Topic, 'No Topic') AS TopicName FROM [course] c LEFT JOIN [topic] t ON c.TopicId = t.TopicId ORDER BY c.CourseId DESC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    litCourseCount.Text = dt.Rows.Count.ToString();
                    lblNoCourses.Visible = dt.Rows.Count == 0;
                    rptCourses.Visible = dt.Rows.Count > 0;
                    if (dt.Rows.Count > 0)
                    {
                        rptCourses.DataSource = dt;
                        rptCourses.DataBind();
                    }
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
                    const string sql = @"SELECT t.TopicId, t.Topic, CAST(t.Description AS nvarchar(500)) AS Description, COUNT(c.CourseId) AS CourseCount FROM [topic] t LEFT JOIN [course] c ON t.TopicId = c.TopicId GROUP BY t.TopicId, t.Topic, CAST(t.Description AS nvarchar(500)) ORDER BY t.TopicId DESC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    litTopicCount.Text = dt.Rows.Count.ToString();
                    lblNoTopics.Visible = dt.Rows.Count == 0;
                    rptTopics.Visible = dt.Rows.Count > 0;
                    if (dt.Rows.Count > 0)
                    {
                        rptTopics.DataSource = dt;
                        rptTopics.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load topics: " + ex.Message);
            }
        }
        private void PopulateTopicDropDown()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string sql = "SELECT TopicId, Topic FROM [topic] ORDER BY Topic";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    ddlCourseTopic.Items.Clear();
                    ddlCourseTopic.Items.Add(new ListItem("-- Select a topic --", ""));
                    foreach (DataRow row in dt.Rows)
                    {
                        ddlCourseTopic.Items.Add(new ListItem(row["Topic"].ToString(), row["TopicId"].ToString()));
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load topics for dropdown: " + ex.Message);
            }
        }
        protected void btnAddCourse_Click(object sender, EventArgs e)
        {
            string name = txtCourseName.Text.Trim();
            string content = txtCourseContent.Text.Trim();
            string code = txtDefaultCode.Text.Trim();
            string topicVal = ddlCourseTopic.SelectedValue;
            if (string.IsNullOrEmpty(name))
            {
                ShowError("Course name is required.");
                return;
            }
            if (string.IsNullOrEmpty(topicVal))
            {
                ShowError("Please select a topic for this course.");
                return;
            }
            int topicId = Convert.ToInt32(topicVal);
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string sql = @"INSERT INTO [course] (TopicId, Name, Content, DefaultCode) VALUES (@TopicId, @Name, @Content, @Code)";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@TopicId", topicId);
                        cmd.Parameters.AddWithValue("@Name", name);
                        cmd.Parameters.AddWithValue("@Content", string.IsNullOrEmpty(content) ? (object)DBNull.Value : content);
                        cmd.Parameters.AddWithValue("@Code", string.IsNullOrEmpty(code) ? (object)DBNull.Value : code);
                        cmd.ExecuteNonQuery();
                    }
                }
                txtCourseName.Text = "";
                txtCourseContent.Text = "";
                txtDefaultCode.Text = "";
                ShowSuccess("Course added successfully.");
                LoadCourses();
                LoadTopics();
                PopulateTopicDropDown();
            }
            catch (Exception ex)
            {
                ShowError("Could not add course: " + ex.Message);
            }
        }
        protected void btnAddTopic_Click(object sender, EventArgs e)
        {
            string topicName = txtTopicName.Text.Trim();
            string topicDesc = txtTopicDesc.Text.Trim();
            if (string.IsNullOrEmpty(topicName))
            {
                ShowError("Topic name is required.");
                return;
            }
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    const string checkSql = "SELECT COUNT(1) FROM [topic] WHERE Topic = @Topic";
                    using (SqlCommand chk = new SqlCommand(checkSql, conn))
                    {
                        chk.Parameters.AddWithValue("@Topic", topicName);
                        int exists = (int)chk.ExecuteScalar();
                        if (exists > 0)
                        {
                            ShowError("A topic with that name already exists.");
                            return;
                        }
                    }
                    const string sql = @"INSERT INTO [topic] (Topic, Description) VALUES (@Topic, @Desc)";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Topic", topicName);
                        cmd.Parameters.AddWithValue("@Desc", string.IsNullOrEmpty(topicDesc) ? (object)DBNull.Value : topicDesc);
                        cmd.ExecuteNonQuery();
                    }
                }
                txtTopicName.Text = "";
                txtTopicDesc.Text = "";
                ShowSuccess("Topic added successfully.");
                LoadCourses();
                LoadTopics();
                PopulateTopicDropDown();
            }
            catch (Exception ex)
            {
                ShowError("Could not add topic: " + ex.Message);
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
                    const string sql = "DELETE FROM [course] WHERE CourseId = @CourseId";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseId", courseID);
                        cmd.ExecuteNonQuery();
                    }
                }
                ShowSuccess("Course deleted successfully.");
                LoadCourses();
                LoadTopics();
                PopulateTopicDropDown();
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
                    const string unlinkSql = "UPDATE [course] SET TopicId = NULL WHERE TopicId = @TopicId";
                    using (SqlCommand cmd = new SqlCommand(unlinkSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@TopicId", topicID);
                        cmd.ExecuteNonQuery();
                    }
                    const string deleteSql = "DELETE FROM [topic] WHERE TopicId = @TopicId";
                    using (SqlCommand cmd2 = new SqlCommand(deleteSql, conn))
                    {
                        cmd2.Parameters.AddWithValue("@TopicId", topicID);
                        cmd2.ExecuteNonQuery();
                    }
                }
                ShowSuccess("Topic deleted successfully.");
                LoadCourses();
                LoadTopics();
                PopulateTopicDropDown();
            }
            catch (Exception ex)
            {
                ShowError("Could not delete topic: " + ex.Message);
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