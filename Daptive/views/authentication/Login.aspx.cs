using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Daptive
{
    public partial class Login : Page
    {
        // ── Connection string – update to match your SQL Server ──────────────
        private readonly string _connStr =
            System.Configuration.ConfigurationManager
                  .ConnectionStrings["CodeDaptiveDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    // NOTE: In production, store hashed passwords (e.g. BCrypt)
                    string sql = @"SELECT UserID, Role
                                   FROM   [user]
                                   WHERE  Username = @Username
                                   AND    Password = @Password";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", password);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                int    userID = (int)reader["UserID"];
                                string role   = reader["Role"].ToString();

                                // Store in Session
                                Session["UserID"]   = userID;
                                Session["Username"] = username;
                                Session["Role"]     = role;

                                // Redirect based on role
                                switch (role.ToLower())
                                {
                                    case "admin":
                                        Response.Redirect("~/Admin/Dashboard.aspx");
                                        break;
                                    case "lecturer":
                                        Response.Redirect("~/Lecturer/Dashboard.aspx");
                                        break;
                                    default:
                                        Response.Redirect("~/views/learner/LearnerView_Dashboard.aspx");
                                        break;
                                }
                            }
                            else
                            {
                                lblMessage.Text    = "Invalid username or password. Please try again.";
                                lblMessage.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text    = "A system error occurred. Please try again later.";
                lblMessage.Visible = true;
                // Log ex.Message to your logging system
            }
        }
    }
}
