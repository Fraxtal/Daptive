using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.Script.Services;
using System.Web.UI;

namespace Daptive.views.lecturer
{
    public partial class StudentResults : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindStudents();
            }
            else
            {
                // If a student id was posted (form submit from client), load their results server-side
                if (!string.IsNullOrEmpty(hfStudentId.Value))
                {
                    btnLoadStudentResults_Click(this, EventArgs.Empty);
                }
            }
        }
        protected void btnsignout_click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/views/authentication/Login.aspx");
        }

        protected void gvStudents_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewResults")
            {
                var arg = Convert.ToString(e.CommandArgument);
                hfStudentId.Value = arg;
                btnLoadStudentResults_Click(this, EventArgs.Empty);
            }
        }

        private void BindStudents()
        {
            var connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand(@"SELECT UserID, COALESCE(NULLIF(FullName, ''), Username) AS DisplayName, Email FROM dbo.[user] WHERE [Role] = 'Student'ORDER BY COALESCE(NULLIF(FullName, ''), Username) ASC", conn))
            using (var da = new SqlDataAdapter(cmd))
            {
                var dt = new DataTable();
                da.Fill(dt);
                gvStudents.DataSource = dt;
                gvStudents.DataBind();
            }
        }

        protected void btnLoadStudentResults_Click(object sender, EventArgs e)
        {
            int userId;
            if (!int.TryParse(hfStudentId.Value, out userId))
            {
                litStudentResults.Text = "<p class='section-hint'>Invalid learner id</p>";
                return;
            }

            // fetch scores server-side and render HTML for modal
            var connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
            var sb = new System.Text.StringBuilder();
            sb.Append("<table class='table'><thead><tr><th>Quiz</th><th>Description</th><th>Score</th></tr></thead><tbody>");
            using (var conn = new SqlConnection(connStr))
            // q.Quiz may be an ntext/text column; cast to nvarchar(max) for ordering to avoid SQL error
            using (var cmd = new SqlCommand(@"SELECT q.Quiz, q.Description, s.Score FROM dbo.score s LEFT JOIN dbo.quiz q ON s.QuizId = q.QuizId WHERE s.UserId = @UserId ORDER BY CASE WHEN q.Quiz IS NULL THEN '' ELSE CAST(q.Quiz AS NVARCHAR(MAX)) END", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    if (!rdr.HasRows)
                    {
                        litStudentResults.Text = "<p class='section-hint'>No quiz results found for this learner.</p>";
                        return;
                    }

                    while (rdr.Read())
                    {
                        var quiz = rdr.IsDBNull(0) ? "(Deleted Quiz)" : rdr.GetString(0);
                        var desc = rdr.IsDBNull(1) ? "(This quiz was deleted)" : rdr.GetString(1);
                        var score = rdr.IsDBNull(2) ? string.Empty : rdr.GetInt32(2).ToString();
                        sb.Append($"<tr><td>{System.Web.HttpUtility.HtmlEncode(quiz)}</td><td>{System.Web.HttpUtility.HtmlEncode(desc)}</td><td>{System.Web.HttpUtility.HtmlEncode(score)}</td></tr>");
                    }
                }
            }
            sb.Append("</tbody></table>");
            litStudentResults.Text = sb.ToString();

            // Show modal on client after postback
            ScriptManager.RegisterStartupScript(this, GetType(), "showStudentModal", "document.getElementById('studentModal').style.display='flex';", true);
        }
    }
}
    