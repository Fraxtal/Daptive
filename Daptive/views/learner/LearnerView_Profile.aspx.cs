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
                                        // Handle case where user is not found
                                        Console.WriteLine("User not found.");
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        // Handle exceptions (e.g., log the error)
                        Console.WriteLine("An error occurred: " + ex.Message);
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
            int curUserId = Convert.ToInt32(Session["UserID"]);
            string updateQuery = "UPDATE [user] SET Username = @Username, FullName = @FullName, Email = @Email, Password = @Password WHERE UserID = @UsrId";
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", txtUsername.Text);
                        cmd.Parameters.AddWithValue("@FullName", txtFullName.Text);
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                        cmd.Parameters.AddWithValue("@Password", txtPassword.Text);
                        cmd.Parameters.AddWithValue("@UsrId", curUserId);
                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();
                        if (rowsAffected > 0)
                        {
                            // Optionally show a success message
                            Console.WriteLine("Profile updated successfully.");
                        }
                        else
                        {
                            // Handle case where update failed
                            Console.WriteLine("Profile update failed.");
                        }
                    }
                }
                ShowMessage("Profile updated successfully!", true);
            }
            catch (Exception ex)
            {
                // Handle exceptions (e.g., log the error)
                ShowMessage("Database error while updating profile, please try again ", false);
            }
        }

        [WebMethod(EnableSession = true)]
        public static bool VerifyPassword(string password)
        {
            if (HttpContext.Current.Session["UserID"] == null)
                return false;
            int userId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            string query = "SELECT COUNT(1) FROM [user] WHERE UserID = @UsrId AND Password = @Pwd";
            try
            {
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@UsrId", userId);
                        cmd.Parameters.AddWithValue("@Pwd", password.Trim());
                        conn.Open();
                        int count = (int)cmd.ExecuteScalar();
                        return count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle exceptions (e.g., log the error)
                return false;
            }
        }

        private void ShowMessage(string msg, bool isSuccess)
        {
            string functionName = isSuccess ? "showSuccessText" : "showErrorText";

            string script = $"{functionName}('{msg.Replace("'", "\\'")}');";

            ScriptManager.RegisterStartupScript(this, GetType(), "ServerToast", script, true);
        }
    }
}