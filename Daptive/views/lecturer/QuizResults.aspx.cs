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
        private void BindResults()        {
            var connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            using (var cmd = new SqlCommand("SELECT q.QuizId, q.Quiz, q.Description, r.CompletedOn FROM [dbo].[quiz] q INNER JOIN [dbo].[quizresult] r ON q.QuizId = r.QuizId ORDER BY r.CompletedOn ASC", conn))
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
