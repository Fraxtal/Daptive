using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using CodeRunner;

namespace Daptive.views
{
    public partial class LearnerView_Assessments : System.Web.UI.Page
    {
        public class Quiz
        {
            public int QuizId { get; set; }
            public string Question { get; set; }
            public bool isCompleted { get; set; }
            public string Score { get; set; }
            public string Description { get; set; }
        }

        public class Result
        {
            public int Score { get; set; }
            public string Message { get; set; }
        }

        private List<Quiz> quizzes { get; set; } = new List<Quiz> { };

        private readonly static string _connStr = System.Configuration.ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string query = @"SELECT q.QuizId, q.Question, q.Description, UserScore.HighestScore FROM quiz q " +
                    "LEFT JOIN (SELECT QuizId, Max(Score) AS HighestScore FROM score " +
                    "WHERE UserID=@UsrId GROUP BY QuizId) AS UserScore ON q.QuizId = UserScore.QuizId";
                try
                {
                    using (SqlConnection conn = new SqlConnection(_connStr))
                    {
                        using (SqlCommand command = new SqlCommand(query, conn))
                        {
                            conn.Open();
                            command.Parameters.AddWithValue("@UsrId", 1);
                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    quizzes.Add(new Quiz
                                    {
                                        QuizId = reader.GetInt32(0),
                                        Question = reader.IsDBNull(1) ? "" : reader.GetString(1),
                                        isCompleted = !reader.IsDBNull(3),
                                        Score = reader.IsDBNull(3) ? "Incomplete" : reader.GetInt32(3).ToString(),
                                        Description = reader.IsDBNull(2) ? "" : reader.GetString(2)
                                    });
                                }
                            }
                        }
                    }
                    rptAssessment.DataSource = quizzes;
                    rptAssessment.DataBind();
                }
                catch (Exception ex)
                {
                    // Handle exceptions (e.g., log the error, show a message to the user, etc.)
                    ShowMessage("An error occurred while loading quizzes. Please try again later.");
                    return;
                }
            }
        }

        [WebMethod(EnableSession = true)]
        public static Result ReviewUsrCodeAJAX(int quizId, string usrCode)
        {
            List<string> testCasesList = new List<string>();
            List<string> expectedResultList = new List<string>();
            string query = "SELECT [TestCase], ExpectedResult FROM testcase WHERE QuizId = @QID";
            using (SqlConnection conn = new SqlConnection(_connStr))
            {
                using (SqlCommand command = new SqlCommand(query, conn))
                {
                    command.Parameters.AddWithValue("@QID", quizId);
                    conn.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            testCasesList.Add(reader.IsDBNull(0) ? "" : reader.GetString(0));
                            expectedResultList.Add(reader.IsDBNull(1) ? "" : reader.GetString(1));
                        }
                    }
                }
            }

            string[] testCases = testCasesList.ToArray();
            string[] expectedResults = expectedResultList.ToArray();
            if (testCases.Length == 0)
            {
                return new Result { Score = -1, Message = "System Error: No test cases found for this quiz." };
            }

            var result = CSharpRunner.CompileAndRun(usrCode, testCases, 3000);

            if (result.IsError)
            {
                return new Result { Score = -1, Message = "Error: \n" + result.ErrorMessage };
            }

            int score = 0;
            System.Text.StringBuilder report = new System.Text.StringBuilder();
            for (int i = 0; i < expectedResults.Length; i++)
            {
                string userOutput = (result.Outputs != null && i < result.Outputs.Length)
                                    ? result.Outputs[i].Trim()
                                    : "";
                if (userOutput == expectedResults[i].Trim())
                {
                    score++;
                }
                else
                {
                    report.AppendLine($"Test case {i + 1} failed. Expected: '{expectedResultList[i]}', but got: '{result.Outputs[i]}'");
                }
            }
            if (!UpdateScore(quizId, score))
            {
                report.AppendLine("\nSomething went wrong! Your attempt will not be recorded, please try again!");
            }
            if (score == testCases.Length)
            {
                return new Result { Score = score, Message = $"Congratulations! All test cases passed.\n\n{report.ToString()}" };
            }
            else
            {
                return new Result { Score = score, Message = $"You passed {score} out of {testCases.Length} test cases.\n\n{report.ToString()}" };
            }
        }

        //helper
        private static bool UpdateScore(int qId, int score)
        {
            try
            {
                int curUserId = 1;
                if (HttpContext.Current.Session["UserID"] != null)
                {
                    curUserId = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
                }
                string query = "INSERT INTO score (Score, QuizId, UserId) VALUES (@Score, @QuizId, @UserId)";
                using (SqlConnection conn = new SqlConnection(_connStr))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Score", score);
                        cmd.Parameters.AddWithValue("@QuizId", qId);
                        cmd.Parameters.AddWithValue("@UserId", curUserId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        private void ShowMessage(string msg)
        {
            string functionName = "showErrorText";

            string script = $"{functionName}('{msg.Replace("'", "\\'")}');";

            ScriptManager.RegisterStartupScript(this, GetType(), "ServerToast", script, true);
        }
    }
}