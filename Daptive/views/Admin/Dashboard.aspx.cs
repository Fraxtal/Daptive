using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Daptive.Admin
{
    public partial class Dashboard : Page
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
                LoadStatCards();
                LoadCourseChart();
                LoadRecentUsers();
            }
        }
        protected void btnSignOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/views/authentication/Login.aspx");
        }
        private void LoadStatCards()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"SELECT COUNT(*) AS TotalUsers, SUM(CASE WHEN Role = 'Student' THEN 1 ELSE 0 END) AS Students, SUM(CASE WHEN Role = 'Lecturer' THEN 1 ELSE 0 END) AS Lecturers FROM [user]";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            litTotalUsers.Text = r["TotalUsers"].ToString();
                            litTotalStudents.Text = r["Students"].ToString();
                            litTotalLecturers.Text = r["Lecturers"].ToString();
                        }
                    }
                    string courseSql = "SELECT COUNT(*) FROM [course]";
                    using (SqlCommand cmd2 = new SqlCommand(courseSql, conn))
                    {
                        litTotalCourses.Text = cmd2.ExecuteScalar().ToString();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadStatCards error: " + ex.Message);
            }
        }
        private void LoadCourseChart()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"SELECT TOP 5 q.Quiz AS CourseName, COUNT(s.ScoreId) AS ActivityCount FROM [quiz] q LEFT JOIN [score] s ON q.QuizId = s.QuizId GROUP BY q.QuizId, q.Quiz ORDER BY ActivityCount DESC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    if (dt.Rows.Count == 0)
                    {
                        dt.Clear();
                        dt.Columns.Clear();
                        string fallback = @"SELECT TOP 5 Name AS CourseName, 0 AS ActivityCount FROM [course] ORDER BY CourseId DESC";
                        using (SqlDataAdapter da2 = new SqlDataAdapter(fallback, conn))
                        {
                            da2.Fill(dt);
                        }
                    }
                    if (dt.Rows.Count == 0)
                    {
                        lblNoCourses.Visible = true;
                        return;
                    }
                    int max = 1;
                    foreach (DataRow row in dt.Rows)
                    {
                        max = Math.Max(max, Convert.ToInt32(row["ActivityCount"]));
                    }
                    dt.Columns.Add("BarPercent", typeof(int));
                    dt.Columns.Add("SortOrder", typeof(int));
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        int count = Convert.ToInt32(dt.Rows[i]["ActivityCount"]);
                        dt.Rows[i]["BarPercent"] = max > 0 ? (count * 100 / max) : 15;
                        dt.Rows[i]["SortOrder"] = i + 1;
                    }
                    rptCourseStats.DataSource = dt;
                    rptCourseStats.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblNoCourses.Visible = true;
                System.Diagnostics.Debug.WriteLine("LoadCourseChart error: " + ex.Message);
            }
        }
        private void LoadRecentUsers()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"SELECT TOP 8 UserID, Username, FullName, Email, Role FROM [user] ORDER BY UserID DESC";
                    DataTable dt = new DataTable();
                    using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                    {
                        da.Fill(dt);
                    }
                    if (dt.Rows.Count == 0)
                    {
                        lblNoUsers.Visible = true;
                        return;
                    }
                    dt.Columns.Add("Initials", typeof(string));
                    dt.Columns.Add("AvatarClass", typeof(string));
                    dt.Columns.Add("RoleBadgeClass", typeof(string));
                    foreach (DataRow row in dt.Rows)
                    {
                        string fullName = row["FullName"] != null ? row["FullName"].ToString() : row["Username"].ToString();
                        string role = row["Role"] != null ? row["Role"].ToString() : "Student";
                        row["Initials"] = GetInitials(fullName);
                        row["AvatarClass"] = GetAvatarClass(role);
                        row["RoleBadgeClass"] = GetRoleBadgeClass(role);
                    }
                    rptRecentUsers.DataSource = dt;
                    rptRecentUsers.DataBind();
                }
            }
            catch (Exception ex)
            {
                lblNoUsers.Visible = true;
                System.Diagnostics.Debug.WriteLine("LoadRecentUsers error: " + ex.Message);
            }
        }
        protected void BtnDeleteUser_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName != "DeleteUser")
            {
                return;
            }
            int userID = Convert.ToInt32(e.CommandArgument);
            if (Session["UserID"] != null && userID == Convert.ToInt32(Session["UserID"]))
            {
                return;
            }
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string deleteScores = "DELETE FROM [score] WHERE UserId = @UserID";
                    using (SqlCommand cmd = new SqlCommand(deleteScores, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        cmd.ExecuteNonQuery();
                    }
                    string deleteUser = "DELETE FROM [user] WHERE UserID = @UserID";
                    using (SqlCommand cmd2 = new SqlCommand(deleteUser, conn))
                    {
                        cmd2.Parameters.AddWithValue("@UserID", userID);
                        cmd2.ExecuteNonQuery();
                    }
                }
                Response.Redirect("Dashboard.aspx");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("DeleteUser error: " + ex.Message);
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
        private static string GetAvatarClass(string role)
        {
            switch (role.ToLower())
            {
                case "lecturer":
                    return "av-blue";
                case "admin":
                    return "av-amber";
                default:
                    return "av-green";
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
    }
}