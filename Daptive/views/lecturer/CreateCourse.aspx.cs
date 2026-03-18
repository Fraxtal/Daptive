using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Daptive.views.lecturer
{
    public partial class CreateCourse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void PublishCourse_Click(object sender, EventArgs e)
        {
            var topicName = txtTopicName.Text.Trim();
            var topicDesc = txtTopicDesc.Text.Trim();
            var lessonsData = hfLessons.Value; // expected as lessonName::content::code separated by ||

            if (string.IsNullOrEmpty(topicName)) return;

            var connStr = System.Configuration.ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (var tran = conn.BeginTransaction())
                {
                    try
                    {
                        int topicId;
                        using (var cmd = new SqlCommand("INSERT INTO [dbo].[topic] ([Topic], [Description]) OUTPUT INSERTED.[TopicId] VALUES (@Topic, @Desc)", conn, tran))
                        {
                            cmd.Parameters.Add(new SqlParameter("@Topic", SqlDbType.NVarChar, 255) { Value = topicName });
                            cmd.Parameters.Add(new SqlParameter("@Desc", SqlDbType.Text) { Value = string.IsNullOrEmpty(topicDesc) ? (object)DBNull.Value : topicDesc });
                            topicId = (int)cmd.ExecuteScalar();
                        }

                        if (!string.IsNullOrEmpty(lessonsData))
                        {
                            var lessons = new List<Tuple<string, string, string>>();
                            var pairs = lessonsData.Split(new[] { "||" }, StringSplitOptions.RemoveEmptyEntries);
                            foreach (var p in pairs)
                            {
                                var parts = p.Split(new[] { "::" }, StringSplitOptions.None);
                                if (parts.Length >= 3)
                                    lessons.Add(Tuple.Create(parts[0], parts[1], parts[2]));
                            }

                            foreach (var l in lessons)
                            {
                                using (var cmd = new SqlCommand("INSERT INTO [dbo].[course] ([TopicId], [Name], [Content], [DefaultCode]) VALUES (@TopicId, @Name, @Content, @Code)", conn, tran))
                                {
                                    cmd.Parameters.Add(new SqlParameter("@TopicId", SqlDbType.Int) { Value = topicId });
                                    cmd.Parameters.Add(new SqlParameter("@Name", SqlDbType.NVarChar, 255) { Value = l.Item1 });
                                    cmd.Parameters.Add(new SqlParameter("@Content", SqlDbType.Text) { Value = string.IsNullOrEmpty(l.Item2) ? (object)DBNull.Value : l.Item2 });
                                    cmd.Parameters.Add(new SqlParameter("@Code", SqlDbType.Text) { Value = string.IsNullOrEmpty(l.Item3) ? (object)DBNull.Value : l.Item3 });
                                    cmd.ExecuteNonQuery();
                                }
                            }
                        }

                        tran.Commit();
                        Response.Write("<script>alert('Course published successfully.');window.location=window.location;</script>");
                    }
                    catch
                    {
                        tran.Rollback();
                        Response.Write("<script>alert('Failed to publish course.');</script>");
                    }
                }
            }
        }
    }
}
