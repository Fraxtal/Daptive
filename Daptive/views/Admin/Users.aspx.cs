using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Daptive.Admin
{
    public partial class Users : Page
    {
        private readonly string _connStr =
            System.Configuration.ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;

        // ── Page Load ─────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (Session["Role"] == null || Session["Role"].ToString().ToLower() != "admin")
            //{
            //    Response.Redirect("~/Login.aspx");
            //    return;
            //}

            if (!IsPostBack)
            {
                string username = Session["Username"] != null ? Session["Username"].ToString() : "Admin";
                litUsername.Text = username;
                litInitials.Text = GetInitials(username);
                LoadUsers("", "");
            }
        }

        // ── Load Users ────────────────────────────────────────────────
        private void LoadUsers(string search, string role)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    string sql = @"
                        SELECT UserID, Username, FullName, Email, Role
                        FROM   [user]
                        WHERE  (@Search = '' OR
                                FullName LIKE '%' + @Search + '%' OR
                                Username LIKE '%' + @Search + '%' OR
                                Email    LIKE '%' + @Search + '%')
                        AND    (@Role = '' OR Role = @Role)
                        ORDER BY UserID DESC";

                    DataTable dt = new DataTable();
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Search", search ?? "");
                        cmd.Parameters.AddWithValue("@Role", role ?? "");
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                            da.Fill(dt);
                    }

                    litUserCount.Text = dt.Rows.Count.ToString();

                    if (dt.Rows.Count == 0)
                    {
                        lblNoUsers.Visible = true;
                        rptUsers.Visible = false;
                        return;
                    }

                    lblNoUsers.Visible = false;
                    rptUsers.Visible = true;

                    // Add computed display columns
                    dt.Columns.Add("Initials", typeof(string));
                    dt.Columns.Add("AvatarClass", typeof(string));
                    dt.Columns.Add("RoleBadgeClass", typeof(string));

                    foreach (DataRow row in dt.Rows)
                    {
                        string fullName = row["FullName"] != null ? row["FullName"].ToString() : row["Username"].ToString();
                        string r = row["Role"] != null ? row["Role"].ToString() : "Student";
                        row["Initials"] = GetInitials(fullName);
                        row["AvatarClass"] = GetAvatarClass(r);
                        row["RoleBadgeClass"] = GetRoleBadgeClass(r);
                    }

                    rptUsers.DataSource = dt;
                    rptUsers.DataBind();
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load users: " + ex.Message);
            }
        }

        // ── Filter ────────────────────────────────────────────────────
        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadUsers(txtSearch.Text.Trim(), ddlFilterRole.SelectedValue);
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlFilterRole.SelectedIndex = 0;
            LoadUsers("", "");
        }

        // ── Show Add Form ─────────────────────────────────────────────
        protected void btnShowAdd_Click(object sender, EventArgs e)
        {
            ClearForm();
            hfEditUserID.Value = "0";
            litFormTitle.Text = "Add New User";
            litPasswordNote.Text = "";
            pnlForm.Visible = true;
        }

        protected void btnCancelForm_Click(object sender, EventArgs e)
        {
            pnlForm.Visible = false;
            ClearForm();
        }

        // ── Save (Insert or Update) ───────────────────────────────────
        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int userID = Convert.ToInt32(hfEditUserID.Value);
            string fullName = txtFullName.Text.Trim();
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string role = ddlRole.SelectedValue;
            string password = txtPassword.Text.Trim();

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    if (userID == 0)
                    {
                        // ── INSERT ──────────────────────────────────
                        if (string.IsNullOrEmpty(password))
                        {
                            ShowError("Password is required when adding a new user.");
                            return;
                        }

                        // Check duplicate username
                        string checkSql = "SELECT COUNT(1) FROM [user] WHERE Username = @Username";
                        using (SqlCommand chk = new SqlCommand(checkSql, conn))
                        {
                            chk.Parameters.AddWithValue("@Username", username);
                            if ((int)chk.ExecuteScalar() > 0)
                            {
                                ShowError("Username already exists. Please choose another.");
                                return;
                            }
                        }

                        // Check duplicate email
                        string checkEmail = "SELECT COUNT(1) FROM [user] WHERE Email = @Email";
                        using (SqlCommand chk2 = new SqlCommand(checkEmail, conn))
                        {
                            chk2.Parameters.AddWithValue("@Email", email);
                            if ((int)chk2.ExecuteScalar() > 0)
                            {
                                ShowError("Email already registered.");
                                return;
                            }
                        }

                        string insertSql = @"
                            INSERT INTO [user] (Username, FullName, Email, Password, Role)
                            VALUES (@Username, @FullName, @Email, @Password, @Role)";

                        using (SqlCommand cmd = new SqlCommand(insertSql, conn))
                        {
                            cmd.Parameters.AddWithValue("@Username", username);
                            cmd.Parameters.AddWithValue("@FullName", fullName);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@Password", password);
                            cmd.Parameters.AddWithValue("@Role", role);
                            cmd.ExecuteNonQuery();
                        }

                        ShowSuccess("User added successfully.");
                    }
                    else
                    {
                        // ── UPDATE ──────────────────────────────────
                        // Check duplicate username (exclude self)
                        string checkSql = "SELECT COUNT(1) FROM [user] WHERE Username = @Username AND UserID != @UserID";
                        using (SqlCommand chk = new SqlCommand(checkSql, conn))
                        {
                            chk.Parameters.AddWithValue("@Username", username);
                            chk.Parameters.AddWithValue("@UserID", userID);
                            if ((int)chk.ExecuteScalar() > 0)
                            {
                                ShowError("Username already taken by another user.");
                                return;
                            }
                        }

                        // Check duplicate email (exclude self)
                        string checkEmail = "SELECT COUNT(1) FROM [user] WHERE Email = @Email AND UserID != @UserID";
                        using (SqlCommand chk2 = new SqlCommand(checkEmail, conn))
                        {
                            chk2.Parameters.AddWithValue("@Email", email);
                            chk2.Parameters.AddWithValue("@UserID", userID);
                            if ((int)chk2.ExecuteScalar() > 0)
                            {
                                ShowError("Email already registered to another user.");
                                return;
                            }
                        }

                        if (!string.IsNullOrEmpty(password))
                        {
                            // Update including password
                            string updateSql = @"
                                UPDATE [user]
                                SET    FullName = @FullName,
                                       Username = @Username,
                                       Email    = @Email,
                                       Role     = @Role,
                                       Password = @Password
                                WHERE  UserID   = @UserID";

                            using (SqlCommand cmd = new SqlCommand(updateSql, conn))
                            {
                                cmd.Parameters.AddWithValue("@FullName", fullName);
                                cmd.Parameters.AddWithValue("@Username", username);
                                cmd.Parameters.AddWithValue("@Email", email);
                                cmd.Parameters.AddWithValue("@Role", role);
                                cmd.Parameters.AddWithValue("@Password", password);
                                cmd.Parameters.AddWithValue("@UserID", userID);
                                cmd.ExecuteNonQuery();
                            }
                        }
                        else
                        {
                            // Update without changing password
                            string updateSql = @"
                                UPDATE [user]
                                SET    FullName = @FullName,
                                       Username = @Username,
                                       Email    = @Email,
                                       Role     = @Role
                                WHERE  UserID   = @UserID";

                            using (SqlCommand cmd = new SqlCommand(updateSql, conn))
                            {
                                cmd.Parameters.AddWithValue("@FullName", fullName);
                                cmd.Parameters.AddWithValue("@Username", username);
                                cmd.Parameters.AddWithValue("@Email", email);
                                cmd.Parameters.AddWithValue("@Role", role);
                                cmd.Parameters.AddWithValue("@UserID", userID);
                                cmd.ExecuteNonQuery();
                            }
                        }

                        ShowSuccess("User updated successfully.");
                    }
                }

                pnlForm.Visible = false;
                ClearForm();
                LoadUsers("", "");
            }
            catch (Exception ex)
            {
                ShowError("Could not save user: " + ex.Message);
            }
        }

        // ── Repeater Commands (Edit / Delete) ─────────────────────────
        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int userID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditUser")
            {
                LoadUserIntoForm(userID);
            }
            else if (e.CommandName == "DeleteUser")
            {
                DeleteUser(userID);
            }
        }

        private void LoadUserIntoForm(int userID)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();
                    string sql = "SELECT UserID, Username, FullName, Email, Role FROM [user] WHERE UserID = @UserID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userID);
                        using (SqlDataReader r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                hfEditUserID.Value = userID.ToString();
                                txtFullName.Text = r["FullName"].ToString();
                                txtUsername.Text = r["Username"].ToString();
                                txtEmail.Text = r["Email"].ToString();
                                ddlRole.SelectedValue = r["Role"].ToString();
                                txtPassword.Text = "";

                                litFormTitle.Text = "Edit User";
                                litPasswordNote.Text = " <span style='font-weight:400; color:var(--text-light);'>(leave blank to keep current)</span>";
                                pnlForm.Visible = true;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Could not load user: " + ex.Message);
            }
        }

        private void DeleteUser(int userID)
        {
            // Prevent deleting yourself
            if (Session["UserID"] != null && userID == Convert.ToInt32(Session["UserID"]))
            {
                ShowError("You cannot delete your own account.");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    conn.Open();

                    // Delete related scores first
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

                ShowSuccess("User deleted successfully.");
                LoadUsers("", "");
            }
            catch (Exception ex)
            {
                ShowError("Could not delete user: " + ex.Message);
            }
        }

        // ── Helpers ───────────────────────────────────────────────────
        private void ClearForm()
        {
            txtFullName.Text = "";
            txtUsername.Text = "";
            txtEmail.Text = "";
            txtPassword.Text = "";
            ddlRole.SelectedIndex = 0;
            hfEditUserID.Value = "0";
        }

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

        private static string GetAvatarClass(string role)
        {
            switch (role.ToLower())
            {
                case "lecturer": return "av-blue";
                case "admin": return "av-amber";
                default: return "av-green";
            }
        }

        private static string GetRoleBadgeClass(string role)
        {
            switch (role.ToLower())
            {
                case "lecturer": return "b-lecturer";
                case "admin": return "b-admin";
                default: return "b-student";
            }
        }
    }
}