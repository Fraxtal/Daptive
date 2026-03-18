using System;
using System.Collections.Generic;
using System.Configuration;
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
                        using (var cmd = new SqlCommand("INSERT INTO topic (Topic, Description) OUTPUT INSERTED.TopicId VALUES (@Topic, @Desc)", conn, tran))
                        {
                            cmd.Parameters.AddWithValue("@Topic", topicName);
                            cmd.Parameters.AddWithValue("@Desc", topicDesc);
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
                                using (var cmd = new SqlCommand("INSERT INTO course (TopicId, Name, Content, DefaultCode) VALUES (@TopicId, @Name, @Content, @Code)", conn, tran))
                                {
                                    cmd.Parameters.AddWithValue("@TopicId", topicId);
                                    cmd.Parameters.AddWithValue("@Name", l.Item1);
                                    cmd.Parameters.AddWithValue("@Content", l.Item2);
                                    cmd.Parameters.AddWithValue("@Code", l.Item3);
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
