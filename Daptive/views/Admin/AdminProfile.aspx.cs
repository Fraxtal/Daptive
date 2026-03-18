using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace Daptive.Admin
{
    public partial class AdminProfile : Page
    {
        private readonly string _connStr =
            System.Configuration.ConfigurationManager
                  .ConnectionStrings["CodeDaptiveDB"].ConnectionString;

        // ── Page Load ─────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (Session["Role"] == null || Session["Role"].ToString().ToLower() != "admin")
            //{
            //    Response.Redirect("~/Login.aspx");
            //    return;
            //}

            if (!IsPostBack)
                LoadProfile();
        }

        // ── Load Profile ──────────────────────────────────────────────
        private void LoadProfile()
        {
            int userID = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = "SELECT Username, FullName, Email FROM [user] WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                string fullName = r["FullName"].ToString();
                                string username = r["Username"].ToString();
                                string email = r["Email"].ToString();

                                // Sidebar
                                litUsername.Text = username;
                                litInitials.Text = GetInitials(fullName);

                                // Profile card
                                litAvatarInitials.Text = GetInitials(fullName);
                                litProfileName.Text = fullName;
                                litProfileUsername.Text = username;
                                litProfileEmail.Text = email;

                                // Form fields
                                txtFullName.Text = fullName;
                                txtUsername.Text = username;
                                txtEmail.Text = email;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load profile: " + ex.Message);
            }
        }

        // ── Update Info ───────────────────────────────────────────────
        protected void btnUpdateInfo_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userID = Convert.ToInt32(Session["UserID"]);
            string fullName = txtFullName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    // Check username not taken by someone else
                    string checkUser = "SELECT COUNT(1) FROM [user] WHERE Username = @Username AND UserID != @UserID";
                    using (SqlCommand chk = new SqlCommand(checkUser, conn))
                    {
                        chk.Parameters.AddWithValue("@Username", username);
                        chk.Parameters.AddWithValue("@UserID", userID);
                        if ((int)chk.ExecuteScalar() > 0)
                        {
                            ShowError("That username is already taken.");
                            return;
                        }
                    }

                    // Check email not taken by someone else
                    string checkEmail = "SELECT COUNT(1) FROM [user] WHERE Email = @Email AND UserID != @UserID";
                    using (SqlCommand chk2 = new SqlCommand(checkEmail, conn))
                    {
                        chk2.Parameters.AddWithValue("@Email", email);
                        chk2.Parameters.AddWithValue("@UserID", userID);
                        if ((int)chk2.ExecuteScalar() > 0)
                        {
                            ShowError("That email is already registered to another account.");
                            return;
                        }
                    }

                    string sql = @"
                        UPDATE [user]
                        SET    FullName = @FullName,
                               Username = @Username,
                               Email    = @Email
                        WHERE  UserID   = @UserID";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", fullName);
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        cmd.ExecuteNonQuery();
                    }
                }

                // Update session so sidebar reflects new username immediately
                Session["Username"] = username;

                ShowSuccess("Profile updated successfully.");
                LoadProfile();
            }
            catch (Exception ex)
            {
                ShowError("Could not update profile: " + ex.Message);
            }
        }

        // ── Change Password ───────────────────────────────────────────
        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userID = Convert.ToInt32(Session["UserID"]);
            string currentPw = txtCurrentPassword.Text.Trim();
            string newPw = txtNewPassword.Text.Trim();

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    // Verify current password
                    string verifySql = "SELECT COUNT(1) FROM [user] WHERE UserID = @UserID AND Password = @Password";
                    using (SqlCommand chk = new SqlCommand(verifySql, conn))
                    {
                        chk.Parameters.AddWithValue("@UserID", userID);
                        chk.Parameters.AddWithValue("@Password", currentPw);
                        if ((int)chk.ExecuteScalar() == 0)
                        {
                            ShowError("Current password is incorrect.");
                            return;
                        }
                    }

                    // Update to new password
                    string updateSql = "UPDATE [user] SET Password = @Password WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(updateSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Password", newPw);
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        cmd.ExecuteNonQuery();
                    }
                }

                // Clear password fields
                txtCurrentPassword.Text = "";
                txtNewPassword.Text = "";
                txtConfirmPassword.Text = "";

                ShowSuccess("Password changed successfully.");
            }
            catch (Exception ex)
            {
                ShowError("Could not change password: " + ex.Message);
            }
        }

        // ── Helpers ───────────────────────────────────────────────────
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
            if (string.IsNullOrWhiteSpace(name)) return "??";
            string[] parts = name.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1)
                return parts[0].Substring(0, Math.Min(2, parts[0].Length)).ToUpper();
            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpper();
        }
    }
}