using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Daptive.views.learner
{
    public partial class LearnerView_Profile : System.Web.UI.Page
    {
        private readonly static string _connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtUsername.Attributes.Add("readonly", "readonly");
                txtFullName.Attributes.Add("readonly", "readonly");
                txtEmail.Attributes.Add("readonly", "readonly");
                txtPassword.Attributes.Add("readonly", "readonly");
                int curUserId = 1;
                if (Session["UserID"] != null)
                {
                    curUserId = Convert.ToInt32(Session["UserID"]);
                    string query = "SELECT UserID, Username, FullName, Email, Password, Role FROM [user] WHERE UserID = @UsrId";
                    try
                    {
                        using (SqlConnection conn = new SqlConnection(_connStr))
                        {
                            using (SqlCommand cmd = new SqlCommand(query, conn))
                            {
                                cmd.Parameters.AddWithValue("@UsrId", curUserId);
                                conn.Open();
                                using (SqlDataReader reader = cmd.ExecuteReader())
                                {
                                    if (reader.Read())
                                    {
                                        txtUserId.Text = reader.IsDBNull(0) ? "" : reader["UserID"].ToString();
                                        txtUsername.Text = reader.IsDBNull(1) ? "" : reader["Username"].ToString();
                                        txtFullName.Text = reader.IsDBNull(2) ? "" : reader["FullName"].ToString();
                                        txtEmail.Text = reader.IsDBNull(3) ? "" : reader["Email"].ToString();
                                        txtPassword.Text = reader.IsDBNull(4) ? "" : reader["Password"].ToString();
                                        txtRole.Text = reader.IsDBNull(5) ? "" : reader["Role"].ToString();
                                    }
                                    else
                                    {
                                        // Handle case where user is not found (which shouldn't happen if session is valid)
                                        ShowMessage("Invalid user! Please try again.", false);
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        // Handle exceptions
                        ShowMessage("Something went wrong! Please try again.", false);
                    }
                }
                else
                {
                    Response.Redirect("~/views/authentication/Login.aspx");
                }
            }
        }

        protected void btnSaveChanges_Click(object sender, EventArgs e)
        {
            var required = new[] { txtUsername, txtFullName, txtEmail, txtPassword };
            foreach (var box in required)
            {
                box.CssClass = "form-control editable-target";
            }

            var emptyFields = required.Where(b => string.IsNullOrWhiteSpace(b.Text)).ToList();

            if (emptyFields.Any())
            {
                foreach (var box in emptyFields)
                {
                    box.CssClass = "is-invalid form-control editable-target";
                }
                ShowMessage("Please fill in all required fields!", false);
                return;
            }

            int curUserId = Convert.ToInt32(Session["UserID"]);
            string updateQuery = "UPDATE [user] SET Username = @Username, FullName = @FullName, Email = @Email, Password = @Password WHERE UserID = @UsrId";
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        string pwd = BCrypt.Net.BCrypt.HashPassword(txtPassword.Text, workFactor: 12);
                        cmd.Parameters.AddWithValue("@Username", txtUsername.Text);
                        cmd.Parameters.AddWithValue("@FullName", txtFullName.Text);
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                        cmd.Parameters.AddWithValue("@Password", pwd);
                        cmd.Parameters.AddWithValue("@UsrId", curUserId);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        if (rowsAffected > 0)
                        {
                            // Optionally show a success message
                            ShowMessage("Update successful!", true);
                        }
                        else
                        {
                            // Handle case where update failed
                            ShowMessage("Profile update failed.", true);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle exceptions (e.g., log the error)
                ShowMessage("Database error while updating profile, please try again ", false);
            }
        }
        protected void btnsignout_click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/views/authentication/Login.aspx");
        }

        [WebMethod(EnableSession = true)]
        public static bool VerifyPassword(string password)
        {
            if (HttpContext.Current.Session["UserID"] == null)
                return false;
            int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            string query = "SELECT Password FROM [user] WHERE UserID = @UsrId";
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UsrId", userId);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            bool isPassed = false;
                            if (reader.Read())
                            {
                                string pwd = reader.IsDBNull(0) ? "" : reader["Password"].ToString();
                                isPassed = BCrypt.Net.BCrypt.Verify(password, pwd);
                            }
                            return isPassed;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle exceptions
                return false;
            }
        }

        private void ShowMessage(string msg, bool isSuccess)
        {
            string functionName = isSuccess ? "showSuccessText" : "showErrorText";

            string script = $"{functionName}('{msg.Replace("'", "\\'")}');";

            ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(), script, true);
        }
    }
}