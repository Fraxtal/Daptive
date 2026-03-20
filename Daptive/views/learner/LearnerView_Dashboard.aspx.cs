using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace Daptive.views.learner
{
    public partial class LearnerView_Dashboard : System.Web.UI.Page
    {
        public class Course
        {
            public int CourseId { get; set; }
            public string Topic { get; set; }
            public string Name { get; set; }
        }

        public class Quiz
        {
            public int QuizId { get; set; }
            public string Question { get; set; }
            public int UserScore { get; set; }
        }

        private readonly static string _connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 1;
                try
                {
                    string quizQuery = @"SELECT TOP 4 q.QuizId, q.Quiz, UserScore.HighestScore FROM quiz q 
                    LEFT JOIN (SELECT QuizId, Max(Score) AS HighestScore FROM score WHERE UserID=@UsrId GROUP BY QuizId)
                    AS UserScore ON q.QuizId = UserScore.QuizId ORDER BY q.QuizId, UserScore.HighestScore DESC";
                    string courseQuery = @"SELECT TOP 3 c.CourseId, t.Topic, c.Name FROM course c
                    LEFT JOIN topic t ON c.TopicId = t.TopicId ORDER BY c.CourseId DESC";
                    using (SqlConnection conn = new SqlConnection(_connStr))
                    {
                        conn.Open();
                        using (SqlCommand cmd = new SqlCommand(quizQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@UsrId", userId);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                List<Quiz> quizzes = new List<Quiz>();
                                while (reader.Read())
                                {
                                    quizzes.Add(new Quiz
                                    {
                                        QuizId = reader.IsDBNull(0) ? 0 : reader.GetInt32(0),
                                        Question = reader.IsDBNull(1) ? "" : reader.GetString(1),
                                        UserScore = reader.IsDBNull(2) ? 0 : reader.GetInt32(2)
                                    });
                                }
                                rptMiniQuizzes.DataSource = quizzes;
                                rptMiniQuizzes.DataBind();
                            }
                        }

                        using (SqlCommand cmd = new SqlCommand(courseQuery, conn))
                        {
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                List<Course> courses = new List<Course>();
                                while (reader.Read())
                                {
                                    courses.Add(new Course
                                    {
                                        CourseId = reader.IsDBNull(0) ? 0 : reader.GetInt32(0),
                                        Topic = reader.IsDBNull(1) ? "" : reader.GetString(1),
                                        Name = reader.IsDBNull(2) ? "" : reader.GetString(2)
                                    });
                                }
                                rptMiniCourses.DataSource = courses;
                                rptMiniCourses.DataBind();
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Handle exceptions
                    ShowMessage("An error occurred while loading your dashboard. Please try again later.");
                    System.Diagnostics.Debug.WriteLine(ex.Message);
                }
            }
        }
        protected void btnsignout_click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/views/authentication/Login.aspx");
        }

        private void ShowMessage(string msg)
        {
            string functionName = "showErrorText";

            string script = $"{functionName}('{msg.Replace("'", "\\'")}');";

            ScriptManager.RegisterStartupScript(this, GetType(), Guid.NewGuid().ToString(), script, true);
        }
    }
}