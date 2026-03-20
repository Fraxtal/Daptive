using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Daptive
{
    public partial class Login : Page
    {
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

                    // Fetch the stored hash + role by username only
                    // (never compare password in SQL when using BCrypt)
                    string sql = @"SELECT UserID, Password, Role
                                   FROM   [user]
                                   WHERE  Username = @Username";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                int userID = (int)reader["UserID"];
                                string storedHash = reader["Password"].ToString();
                                string role = reader["Role"].ToString();
                                bool passwordMatch = BCrypt.Net.BCrypt.Verify(password, storedHash);

                                if (passwordMatch)
                                {
                                    // Store in Session
                                    Session["UserID"] = userID;
                                    Session["Username"] = username;
                                    Session["Role"] = role;

                                    // Redirect based on role
                                    switch (role.ToLower())
                                    {
                                        case "admin":
                                            Response.Redirect("~/views/Admin/Dashboard.aspx");
                                            break;
                                        case "lecturer":
                                            Response.Redirect("~/views/lecturer/LecturerDashboard.aspx");
                                            break;
                                        default:
                                            Response.Redirect("~/views/learner/LearnerView_Dashboard.aspx");
                                            break;
                                    }
                                }
                                else
                                {
                                    // Password wrong — same message as "user not found"
                                    // to avoid revealing which part is incorrect
                                    lblMessage.Text = "Invalid username or password. Please try again." ;
                                    lblMessage.Visible = true;
                                }
                            }
                            else
                            {
                                // Username not found
                                lblMessage.Text = "Invalid username or password. Please try again.";
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
            }
        }
    }
}
