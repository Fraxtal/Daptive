using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Daptive
{
    public partial class Register : Page
    {
        private readonly string _connStr =
            System.Configuration.ConfigurationManager
                  .ConnectionStrings["CodeDaptiveDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string username = txtUsername.Text.Trim();
            string fullName = txtFullName.Text.Trim();
            string email    = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();
            string role     = rbLecturer.Checked ? "Lecturer" : "Student";

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    // 1. Check if username already exists
                    string checkSql = "SELECT COUNT(1) FROM Account WHERE Username = @Username";
                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Username", username);
                        int count = (int)checkCmd.ExecuteScalar();
                        if (count > 0)
                        {
                            lblMessage.Text    = "Username already taken. Please choose another.";
                            lblMessage.Visible = true;
                            return;
                        }
                    }

                    // 2. Check if email already registered
                    string emailCheckSql = "SELECT COUNT(1) FROM Account WHERE Email = @Email";
                    using (SqlCommand emailCmd = new SqlCommand(emailCheckSql, conn))
                    {
                        emailCmd.Parameters.AddWithValue("@Email", email);
                        int count = (int)emailCmd.ExecuteScalar();
                        if (count > 0)
                        {
                            lblMessage.Text    = "This email is already registered.";
                            lblMessage.Visible = true;
                            return;
                        }
                    }

                    // 3. Insert new account
                    // NOTE: Hash password before storing in production!
                    string insertSql = @"INSERT INTO Account (Username, FullName, Email, Password, Role)
                                         VALUES (@Username, @FullName, @Email, @Password, @Role)";

                    using (SqlCommand insertCmd = new SqlCommand(insertSql, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@Username", username);
                        insertCmd.Parameters.AddWithValue("@FullName", fullName);
                        insertCmd.Parameters.AddWithValue("@Email",    email);
                        insertCmd.Parameters.AddWithValue("@Password", password);
                        insertCmd.Parameters.AddWithValue("@Role",     role);
                        insertCmd.ExecuteNonQuery();
                    }

                    lblSuccess.Text    = "Account created successfully! You can now sign in.";
                    lblSuccess.Visible = true;
                    lblMessage.Visible = false;

                    // Clear form
                    txtUsername.Text        = "";
                    txtFullName.Text        = "";
                    txtEmail.Text           = "";
                    txtPassword.Text        = "";
                    txtConfirmPassword.Text = "";
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text    = "Registration failed. Please try again.";
                lblMessage.Visible = true;
                // Log ex.Message
            }
        }
    }
}
