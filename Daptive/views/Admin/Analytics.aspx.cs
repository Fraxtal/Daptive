using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Daptive.views.Admin
{
    public partial class Analytics : Page
    {
        private readonly string _connStr = System.Configuration.ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (Session["Role"] == null || Session["Role"].ToString().ToLower() != "admin")
            //{
            //    Response.Redirect("~/Login.aspx");
            //    return;
            //}
            Session["Role"] = "admin";
            Session["Username"] = "Admin";
            Session["UserID"] = 1;
            if (!IsPostBack)
            {
                string username = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
                litUsername.Text = username;
                litInitials.Text = GetInitials(username);

                LoadTotalCounts();
                LoadUserBreakdown();
                LoadPlatformSummary();
            }
        }

        private void LoadTotalCounts()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"
                        SELECT
                            (SELECT COUNT(*) FROM [user])     AS TotalUsers,
                            (SELECT COUNT(*) FROM [course])   AS TotalCourses,
                            (SELECT COUNT(*) FROM [question]) AS TotalQuestions,
                            (SELECT COUNT(*) FROM [testcase]) AS TotalTestCases";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            litTotalUsers.Text = r["TotalUsers"].ToString();
                            litTotalCourses.Text = r["TotalCourses"].ToString();
                            litTotalQuestions.Text = r["TotalQuestions"].ToString();
                            litTotalTestCases.Text = r["TotalTestCases"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadTotalCounts error: " + ex.Message);
            }
        }

        private void LoadUserBreakdown()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"
                        SELECT
                            COUNT(*)                                            AS TotalUsers,
                            SUM(CASE WHEN Role = 'Student'  THEN 1 ELSE 0 END) AS Students,
                            SUM(CASE WHEN Role = 'Lecturer' THEN 1 ELSE 0 END) AS Lecturers,
                            SUM(CASE WHEN Role = 'admin'    THEN 1 ELSE 0 END) AS Admins
                        FROM [user]";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            int total = Convert.ToInt32(r["TotalUsers"]);
                            int students = Convert.ToInt32(r["Students"]);
                            int lecturers = Convert.ToInt32(r["Lecturers"]);
                            int admins = Convert.ToInt32(r["Admins"]);

                            litStudentCount.Text = students.ToString();
                            litLecturerCount.Text = lecturers.ToString();
                            litAdminCount.Text = admins.ToString();
                            litStudentPct.Text = total > 0 ? (students * 100 / total).ToString() : "0";
                            litLecturerPct.Text = total > 0 ? (lecturers * 100 / total).ToString() : "0";
                            litAdminPct.Text = total > 0 ? (admins * 100 / total).ToString() : "0";

                            if (total == 0) { lblNoUsers.Visible = true; return; }

                            DataTable dt = new DataTable();
                            dt.Columns.Add("Role", typeof(string));
                            dt.Columns.Add("Count", typeof(int));
                            dt.Columns.Add("Percentage", typeof(int));
                            dt.Columns.Add("BadgeClass", typeof(string));

                            dt.Rows.Add("Student", students, total > 0 ? students * 100 / total : 0, "b-student");
                            dt.Rows.Add("Lecturer", lecturers, total > 0 ? lecturers * 100 / total : 0, "b-lecturer");
                            dt.Rows.Add("Admin", admins, total > 0 ? admins * 100 / total : 0, "b-admin");

                            rptRoleSummary.DataSource = dt;
                            rptRoleSummary.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUserBreakdown error: " + ex.Message);
            }
        }

        private void LoadPlatformSummary()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = @"
                        SELECT
                            (SELECT COUNT(*) FROM [user])     AS TotalUsers,
                            (SELECT COUNT(*) FROM [course])   AS TotalCourses,
                            (SELECT COUNT(*) FROM [topic])    AS TotalTopics,
                            (SELECT COUNT(*) FROM [question]) AS TotalQuestions,
                            (SELECT COUNT(*) FROM [testcase]) AS TotalTestCases,
                            (SELECT COUNT(*) FROM [score])    AS TotalScores";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    using (SqlDataReader r = cmd.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            int totalQuestions = Convert.ToInt32(r["TotalQuestions"]);
                            int totalTestCases = Convert.ToInt32(r["TotalTestCases"]);

                            litSummaryUsers.Text = r["TotalUsers"].ToString();
                            litSummaryCourses.Text = r["TotalCourses"].ToString();
                            litSummaryTopics.Text = r["TotalTopics"].ToString();
                            litSummaryQuestions.Text = totalQuestions.ToString();
                            litSummaryTestCases.Text = totalTestCases.ToString();
                            litSummaryScores.Text = r["TotalScores"].ToString();
                            litAvgTestCases.Text = totalQuestions > 0 ? (totalTestCases / totalQuestions).ToString() : "0";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadPlatformSummary error: " + ex.Message);
            }
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
