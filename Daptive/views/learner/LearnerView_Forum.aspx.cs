using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Daptive.Admin;
using static Daptive.views.learner.LearnerView_Dashboard;

namespace Daptive.views.learner
{
    public partial class LearnerView_Forum : System.Web.UI.Page
    {
        public class ForumMessage
        {
            public int ForumId { get; set; }
            public string Author { get; set; }
            public string Title { get; set; }
            public string Content { get; set; }
            public DateTime PostedAt { get; set; }
        }

        public class ForumReply
        {
            public int CommentId { get; set; }
            public string Author { get; set; }
            public string Content { get; set; }
            public DateTime PostedAt { get; set; }
        }

        private readonly static string _connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 1;
                try
                {
                    string query = @"SELECT f.ForumId, u.Username, f.Title, f.Content, f.Date From forum f LEFT JOIN [user] u ON f.UserId = u.UserID ORDER BY f.Date DESC, f.ForumId DESC";
                    using (SqlConnection conn = new SqlConnection(_connStr))
                    {
                        conn.Open();
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@UsrId", userId);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                List<ForumMessage> msg = new List<ForumMessage>();
                                while (reader.Read())
                                {
                                    msg.Add(new ForumMessage
                                    {
                                        ForumId = reader.IsDBNull(0) ? 0 : reader.GetInt32(0),
                                        Author = reader.IsDBNull(1) ? "" : reader.GetString(1),
                                        Title = reader.IsDBNull(2) ? "" : reader.GetString(2),
                                        Content = reader.IsDBNull(3) ? "" : reader.GetString(3),
                                        PostedAt = reader.IsDBNull(4) ? DateTime.MinValue : reader.GetDateTime(4)

                                    });
                                }
                                rptForum.DataSource = msg;
                                rptForum.DataBind();
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Handle exceptions
                    ShowMessage("An error occurred while loading your dashboard. Please try again later.", false);
                }
            }
        }

        protected void btnsignout_click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/views/authentication/Login.aspx");
        }

        [WebMethod(EnableSession = true)]
        public static int SendReplyAJAX(int ForumId, string message)
        {
            int userId = HttpContext.Current.Session["UserId"] != null ? Convert.ToInt32(HttpContext.Current.Session["UserId"]) : 1;
            if (string.IsNullOrEmpty(message))
            {
                return 1;
            }
            try
            {
                string query = @"INSERT INTO comment (ForumId, UserId, Content, Date) VALUES (@ForumId, @UserId, @Content, @Date)";
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@ForumId", ForumId);
                        cmd.Parameters.AddWithValue("@Content", message);
                        cmd.Parameters.AddWithValue("@Date", DateTime.Now);
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0 ? 0 : 2;
                    }
                }
            }
            catch (Exception)
            {
                // Handle exceptions
                return 2;
            }
        }

        [WebMethod(EnableSession = true)]
        public static int SendPostAJAX(string title, string content)
        {
            int userId = HttpContext.Current.Session["UserId"] != null ? Convert.ToInt32(HttpContext.Current.Session["UserId"]) : 1;
            string t = title.Trim();
            string c = content.Trim();
            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(content))
            {
                return 1;
            }
            try
            {
                string query = @"INSERT INTO forum (UserId, Title, Content, Date) VALUES (@UserId, @Title, @Content, @Date)";
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Content", content);
                        cmd.Parameters.AddWithValue("@Date", DateTime.Now);
                        int rowsAffected = cmd.ExecuteNonQuery();
                        return rowsAffected > 0 ? 0 : 2;
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle exceptions
                return 2;
            }
        }

        [WebMethod(EnableSession = true)]
        public static List<ForumReply> GetRepliesAJAX(int ForumId)
        {
            int userId = HttpContext.Current.Session["UserId"] != null ? Convert.ToInt32(HttpContext.Current.Session["UserId"]) : 1;
            List<ForumReply> rply = new List<ForumReply>();
            try
            {
                string query = @"SELECT c.CommentId, u.Username, c.Content, c.Date From comment c LEFT JOIN [user] u ON c.UserId = u.UserID LEFT JOIN forum f ON c.ForumId = f.ForumId WHERE c.ForumId = @ForumId ORDER BY c.Date DESC";
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@ForumId", ForumId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                rply.Add(new ForumReply
                                {
                                    CommentId = reader.IsDBNull(0) ? 0 : reader.GetInt32(0),
                                    Author = reader.IsDBNull(1) ? "" : reader.GetString(1),
                                    Content = reader.IsDBNull(2) ? "" : reader.GetString(2),
                                    PostedAt = reader.IsDBNull(3) ? DateTime.MinValue : reader.GetDateTime(3)

                                });
                            }
                            return rply;
                        }
                    }
                }
            }
            catch (Exception) { rply.Add(new ForumReply { CommentId = 1, Author = "error", Content = "", PostedAt = DateTime.MinValue });  return rply; }
        }
        private void ShowMessage(string msg, bool isSuccess)
        {
            string functionName = isSuccess ? "showSuccessText" : "showErrorText";

            string script = $"{functionName}('{msg.Replace("'", "\\'")}');";

            ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(), script, true);
        }
    }
}