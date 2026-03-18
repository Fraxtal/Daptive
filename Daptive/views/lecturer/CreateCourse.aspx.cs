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
            if (!IsPostBack)
            {
                LoadExistingTopics();
            }
        }

        private void LoadExistingTopics()
        {
            var connStr = ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (var cmd = new SqlCommand("SELECT TopicId, Topic FROM [dbo].[topic] ORDER BY Topic", conn))
                using (var rdr = cmd.ExecuteReader())
                {
                    ddlExistingTopics.Items.Clear();
                    ddlExistingTopics.Items.Add(new ListItem("-- Select existing topic --", ""));
                    while (rdr.Read())
                    {
                        var id = rdr.GetInt32(0);
                        var t = rdr.IsDBNull(1) ? string.Empty : rdr.GetString(1);
                        ddlExistingTopics.Items.Add(new ListItem(t, id.ToString()));
                    }
                }
            }
        }

        protected void PublishCourse_Click(object sender, EventArgs e)
        {
            // If an existing topic is selected, use it; otherwise create new topic from textbox
            int selectedTopicId = 0;
            if (!string.IsNullOrEmpty(ddlExistingTopics.SelectedValue))
            {
                int.TryParse(ddlExistingTopics.SelectedValue, out selectedTopicId);
            }

            var topicName = txtTopicName.Text.Trim();
            var topicDesc = txtTopicDesc.Text.Trim();
            var lessonsData = hfLessons.Value; // expected as lessonName::content::code separated by ||

            if (string.IsNullOrEmpty(topicName))
            {
                Response.Write("<script>alert('Please enter a topic name.');</script>");
                return;
            }

            var connStr = System.Configuration.ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (var tran = conn.BeginTransaction())
                {
                    try
                    {
                        int topicId = selectedTopicId;
                        if (topicId == 0)
                        {
                            using (var cmd = new SqlCommand("INSERT INTO [dbo].[topic] ([Topic], [Description]) OUTPUT INSERTED.[TopicId] VALUES (@Topic, @Desc)", conn, tran))
                            {
                                cmd.Parameters.Add(new SqlParameter("@Topic", SqlDbType.NVarChar, 255) { Value = topicName });
                                cmd.Parameters.Add(new SqlParameter("@Desc", SqlDbType.Text) { Value = string.IsNullOrEmpty(topicDesc) ? (object)DBNull.Value : topicDesc });
                                topicId = (int)cmd.ExecuteScalar();
                            }
                        }

                        var lessons = new List<Tuple<string, string, string>>();
                        if (!string.IsNullOrEmpty(lessonsData))
                        {
                            var pairs = lessonsData.Split(new[] { "||" }, StringSplitOptions.RemoveEmptyEntries);
                            foreach (var p in pairs)
                            {
                                var parts = p.Split(new[] { "::" }, StringSplitOptions.None);
                                if (parts.Length >= 3)
                                {
                                    var name = parts[0].Trim();
                                    var content = parts[1].Trim();
                                    var code = parts[2].Trim();
                                    lessons.Add(Tuple.Create(name, content, code));
                                }
                            }
                        }

                        if (lessons.Count < 1)
                        {
                            // No lessons provided - rollback and alert
                            Response.Write("<script>alert('Please add at least one lesson before publishing the course.');</script>");
                            tran.Rollback();
                            return;
                        }

                        // Validate lesson fields and insert
                        foreach (var l in lessons)
                        {
                            if (string.IsNullOrEmpty(l.Item1) || string.IsNullOrEmpty(l.Item2))
                            {
                                Response.Write("<script>alert('Each lesson must have a name and content.');</script>");
                                tran.Rollback();
                                return;
                            }

                            using (var cmd = new SqlCommand("INSERT INTO [dbo].[course] ([TopicId], [Name], [Content], [DefaultCode]) VALUES (@TopicId, @Name, @Content, @Code)", conn, tran))
                            {
                                cmd.Parameters.Add(new SqlParameter("@TopicId", SqlDbType.Int) { Value = topicId });
                                cmd.Parameters.Add(new SqlParameter("@Name", SqlDbType.NVarChar, 255) { Value = l.Item1 });
                                cmd.Parameters.Add(new SqlParameter("@Content", SqlDbType.Text) { Value = string.IsNullOrEmpty(l.Item2) ? (object)DBNull.Value : l.Item2 });
                                cmd.Parameters.Add(new SqlParameter("@Code", SqlDbType.Text) { Value = string.IsNullOrEmpty(l.Item3) ? (object)DBNull.Value : l.Item3 });
                                cmd.ExecuteNonQuery();
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
