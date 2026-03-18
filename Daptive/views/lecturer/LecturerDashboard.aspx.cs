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

                    // Total students
                    using (var cmd = new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM [user] WHERE Role = 'Student'", conn))
                    {
                        var val = cmd.ExecuteScalar();
                        totalStudents.InnerText = val != null ? val.ToString() : "0";
                    }

                    // Quizzes created by this lecturer (assuming quiz table has a CreatedBy or LecturerId column)
                    // Fallback to total quizzes if no lecturer mapping
                    string quizSql = "SELECT COUNT(*) FROM [quiz]";
                    try
                    {
                        using (var testCmd = new System.Data.SqlClient.SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'quiz' AND COLUMN_NAME = 'CreatedBy'", conn))
                        {
                            var has = Convert.ToInt32(testCmd.ExecuteScalar());
                            if (has > 0 && Session["UserID"] != null)
                                quizSql = "SELECT COUNT(*) FROM [quiz] WHERE CreatedBy = @UserID";
                        }
                    }
                    catch { }

                    using (var cmd2 = new System.Data.SqlClient.SqlCommand(quizSql, conn))
                    {
                        if (quizSql.Contains("@UserID") && Session["UserID"] != null)
                            cmd2.Parameters.AddWithValue("@UserID", Convert.ToInt32(Session["UserID"]));
                        quizzesCreated.InnerText = cmd2.ExecuteScalar().ToString();
                    }

                    // Average completion and score across quizzes
                    // These tables may vary; attempt to compute from score/attempt tables if present
                    double avgCompletionVal = 0.0;
                    double avgScoreVal = 0.0;
                    bool computed = false;
                    try
                    {
                        string attemptSql = @"SELECT AVG(CAST(Completed AS FLOAT)) FROM [attempt]"; // Example
                        using (var cmd3 = new System.Data.SqlClient.SqlCommand(attemptSql, conn))
                        {
                            var a = cmd3.ExecuteScalar();
                            if (a != null && a != DBNull.Value)
                            {
                                avgCompletionVal = Convert.ToDouble(a) * 100.0;
                                computed = true;
                            }
                        }

                        string scoreSql = @"SELECT AVG(CAST(Score AS FLOAT)) FROM [score]";
                        using (var cmd4 = new System.Data.SqlClient.SqlCommand(scoreSql, conn))
                        {
                            var s = cmd4.ExecuteScalar();
                            if (s != null && s != DBNull.Value)
                            {
                                avgScoreVal = Convert.ToDouble(s);
                                computed = true;
                            }
                        }
                    }
                    catch
                    {
                        // ignore if tables not present
                    }

                    if (computed)
                    {
                        avgCompletion.InnerText = Math.Round(avgCompletionVal, 0) + "%";
                        avgScore.InnerText = Math.Round(avgScoreVal, 0) + "%";
                    }
                    else
                    {
                        avgCompletion.InnerText = "--";
                        avgScore.InnerText = "--";
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadStatCards error: " + ex.Message);
            }
        }
    }
}