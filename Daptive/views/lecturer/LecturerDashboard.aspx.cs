using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Daptive.views.lecturer
{
    public partial class LecturerDashboard : System.Web.UI.Page
    {
        private readonly string _connStr = System.Configuration.ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Simulate a logged-in lecturer for now if session not set
            if (Session["Role"] == null || Session["Role"].ToString().ToLower() != "lecturer")
            {
                Session["Role"] = "lecturer";
                Session["Username"] = "LecturerUser";
                Session["UserID"] = 2; // example
            }

            if (!IsPostBack)
            {
                LoadStatCards();
                LoadRecentActivity();
            }
        }
        protected void btnsignout_click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/views/authentication/Login.aspx");
        }

        private void LoadRecentActivity()
        {
            try
            {
                var dt = new DataTable();
                dt.Columns.Add("FullName", typeof(string));
                dt.Columns.Add("ActionText", typeof(string));

                using (var conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    // Prefer a [score] table if present
                    bool hasScore = false;
                    using (var chk = new SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'score'", conn))
                        hasScore = Convert.ToInt32(chk.ExecuteScalar()) > 0;

                    if (hasScore)
                    {
                        string sql = @"SELECT TOP 8 s.ScoreId, u.FullName, s.Score
                                        FROM [score] s
                                        LEFT JOIN [user] u ON s.UserId = u.UserID
                                        ORDER BY s.ScoreId DESC";
                        using (var cmd = new SqlCommand(sql, conn))
                        using (var rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                string user = rdr["FullName"] != DBNull.Value ? rdr["FullName"].ToString() : "Unknown";
                                string score = rdr["Score"] != DBNull.Value ? rdr["Score"].ToString() : "0";
                                var row = dt.NewRow();
                                row["FullName"] = user;
                                row["ActionText"] = "scored " + score + "%";
                                dt.Rows.Add(row);
                            }
                        }
                    }
                    else
                    {
                        // Fallback to attempt/submission table
                        bool hasAttempt = Convert.ToInt32(new SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'attempt'", conn).ExecuteScalar()) > 0;
                        if (hasAttempt)
                        {
                            string sql = @"SELECT TOP 8 a.AttemptId, u.FullName, a.Status
                                            FROM [attempt] a
                                            LEFT JOIN [user] u ON a.UserId = u.UserID
                                            ORDER BY a.AttemptId DESC";
                            using (var cmd = new SqlCommand(sql, conn))
                            using (var rdr = cmd.ExecuteReader())
                            {
                                while (rdr.Read())
                                {
                                    string user = rdr["FullName"] != DBNull.Value ? rdr["FullName"].ToString() : "Unknown";
                                    string status = rdr["Status"] != DBNull.Value ? rdr["Status"].ToString() : "updated";
                                    var row = dt.NewRow();
                                    row["FullName"] = user;
                                    row["ActionText"] = status;
                                    dt.Rows.Add(row);
                                }
                            }
                        }
                    }
                }

                if (dt.Rows.Count > 0)
                {
                    rptRecentActivity.DataSource = dt;
                    rptRecentActivity.DataBind();
                    noRecentActivity.Visible = false;
                }
                else
                {
                    noRecentActivity.Visible = true;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadRecentActivity error: " + ex.Message);
            }
        }

        private void LoadStatCards()
        {
            try
            {
                using (var conn = new System.Data.SqlClient.SqlConnection(_connStr))
                {
                    conn.Open();

                    // Total students (users with Role = 'Student')
                    int totalStudentsCount = 0;
                    using (var cmd = new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM [user] WHERE LOWER(Role) = 'student'", conn))
                    {
                        var val = cmd.ExecuteScalar();
                        totalStudentsCount = val != null && val != DBNull.Value ? Convert.ToInt32(val) : 0;
                        totalStudents.InnerText = totalStudentsCount.ToString();
                    }

                    // Total quizzes
                    using (var cmdQ = new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM [quiz]", conn))
                    {
                        var qv = cmdQ.ExecuteScalar();
                        quizzesCreated.InnerText = qv != null && qv != DBNull.Value ? qv.ToString() : "0";
                    }

                    // Average score across all entries in `score` table
                    double avgScoreVal = -1;
                    using (var cmdS = new System.Data.SqlClient.SqlCommand("SELECT AVG(CAST(Score AS FLOAT)) FROM [score]", conn))
                    {
                        var s = cmdS.ExecuteScalar();
                        if (s != null && s != DBNull.Value)
                        {
                            avgScoreVal = Convert.ToDouble(s);
                        }
                    }

                    // Completion rate: distinct users in `score` divided by total students
                    int distinctUsersWithScores = 0;
                    using (var cmdU = new System.Data.SqlClient.SqlCommand("SELECT COUNT(DISTINCT UserId) FROM [score]", conn))
                    {
                        var u = cmdU.ExecuteScalar();
                        distinctUsersWithScores = u != null && u != DBNull.Value ? Convert.ToInt32(u) : 0;
                    }

                    if (totalStudentsCount > 0)
                    {
                        var completionPct = Math.Round((distinctUsersWithScores * 100.0) / totalStudentsCount, 0);
                        avgCompletion.InnerText = completionPct + "%";
                    }
                    else
                    {
                        avgCompletion.InnerText = "--";
                    }

                    if (avgScoreVal >= 0)
                        avgScore.InnerText = Math.Round(avgScoreVal, 0) + "%";
                    else
                        avgScore.InnerText = "--";
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadStatCards error: " + ex.Message);
            }
        }
    }
}