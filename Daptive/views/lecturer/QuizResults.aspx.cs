using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Daptive.views.lecturer
{
    public partial class QuizResults : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindResults();
            }
        }

        private void BindResults()
        {
            var connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                // Use the existing score table which links users to quizzes with a score.
                // Show quiz title, learner username and score, ordered ascending by score.
                var sql = @"IF OBJECT_ID('dbo.score','U') IS NOT NULL
                                SELECT s.ScoreId,
                                       COALESCE(q.QuizId, s.QuizId) AS QuizId,
                                       CASE WHEN q.Quiz IS NULL THEN '(Deleted Quiz)' ELSE q.Quiz END AS Quiz,
                                       CASE WHEN q.Quiz IS NULL THEN '(This quiz was deleted)' ELSE q.Description END AS Description,
                                       u.UserID,
                                       u.Username,
                                       COALESCE(NULLIF(u.FullName, ''), u.Username) AS Learner,
                                       s.Score
                                FROM dbo.score s
                                LEFT JOIN dbo.quiz q ON s.QuizId = q.QuizId
                                INNER JOIN dbo.[user] u ON s.UserId = u.UserID
                                ORDER BY s.Score ASC

                                -- include CompletedOn so GridView can bind to it
                              ELSE
                                SELECT TOP (0) NULL AS ScoreId, q.QuizId AS QuizId, q.Quiz AS Quiz, q.Description AS Description, NULL AS UserID, NULL AS Username, NULL AS Learner, NULL AS Score FROM dbo.quiz q";

                using (var cmd = new SqlCommand(sql, conn))
                using (var da = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    da.Fill(dt);
                    gvResults.DataSource = dt;
                    gvResults.DataBind();
                }
            }
        }
    }
}
