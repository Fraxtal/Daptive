using System;
using System.Collections.Generic;
using System.Diagnostics.PerformanceData;
using System.Linq;
using System.Runtime.Remoting.Messaging;
using System.Web;
using System.Web.UI;
using System.Web.Services;
using System.Web.UI.WebControls;
using CodeRunner;
using System.Configuration;
using System.Data.SqlClient;

namespace Daptive.views
{
    public partial class LearnerView_Courses : System.Web.UI.Page
    {
        public class Courses
        {
            public int Id { get; set; }
            public int TopicId { get; set; }
            public string Name { get; set; }
            public string Content { get; set; }
            public string DefaultCode { get; set; }
        }

        public class Topics
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
        }

        public class Result
        {
            public bool IsPassed { get; set; }
            public string Message { get; set; }
        }
        private List<Courses> courses { get; set; } = new List<Courses> { };
        private List<Topics> topics { get; set; } = new List<Topics> { };

        private readonly string _connStr = System.Configuration.ConfigurationManager.ConnectionStrings["CodeDaptiveDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(_connStr))
                    {
                        conn.Open();
                        // Load Topics
                        using (SqlCommand cmd = new SqlCommand("SELECT TopicId, Topic, Description FROM topic", conn))
                        {
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    topics.Add(new Topics
                                    {
                                        Id = reader.GetInt32(0),
                                        Name = reader.GetString(1),
                                        Description = reader.IsDBNull(2) ? "" : reader.GetString(2)
                                    });
                                }
                            }
                            rptSidebar.DataSource = topics;
                            rptSidebar.DataBind();
                        }
                    }
                }
                catch (Exception ex)
                {
                    // Handle exceptions (e.g., log the error)
                    System.Diagnostics.Debug.WriteLine("Error loading topics: " + ex.Message);
                }
            }
            
        }

        protected void rptSidebar_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "LoadCourse")
            {
                try
                {
                    int id = Convert.ToInt32(e.CommandArgument);
                    string currentTopicName = "";
                    string currentTopicDesc = "";

                    using (SqlConnection conn = new SqlConnection(_connStr))
                    {
                        conn.Open();
                        using (SqlCommand cmdTopic = new SqlCommand("SELECT Topic, Description FROM [topic] WHERE TopicId = @TopicId", conn))
                        {
                            cmdTopic.Parameters.AddWithValue("@TopicId", id);
                            using (SqlDataReader readerTopic = cmdTopic.ExecuteReader())
                            {
                                if (readerTopic.Read())
                                {
                                    currentTopicName = readerTopic.GetString(0);
                                    currentTopicDesc = readerTopic.IsDBNull(1) ? "" : readerTopic.GetString(1);
                                }
                            }
                        }
                        // Load Courses
                        using (SqlCommand cmd = new SqlCommand("SELECT CourseId, TopicId, Name, Content, DefaultCode " +
                            " FROM course" +
                            " WHERE TopicId = @TopicId", conn))
                        {
                            cmd.Parameters.AddWithValue("@TopicId", id);
                            using (SqlDataReader reader = cmd.ExecuteReader())
                            {
                                courses.Clear();
                                while (reader.Read())
                                {
                                    courses.Add(new Courses
                                    {
                                        Id = reader.GetInt32(0),
                                        TopicId = reader.IsDBNull(1) ? -1 : reader.GetInt32(1),
                                        Name = reader.IsDBNull(2) ? "" : reader.GetString(2),
                                        Content = reader.IsDBNull(3) ? "" : reader.GetString(3),
                                        DefaultCode = reader.IsDBNull(4) ? "" : reader.GetString(4)
                                    });
                                }
                            }
                        }
                    }

                    if (courses.Count > 0)
                    {
                        rptContent.DataSource = this.courses;
                        rptContent.DataBind();

                        
                    }
                    contentTopic.InnerText = currentTopicName;
                    contentTopicDesc.Text = currentTopicDesc;
                }
                catch (Exception ex)
                {
                    // Handle exceptions (e.g., log the error)
                    System.Diagnostics.Debug.WriteLine("Error loading courses: " + ex.Message);
                }
            }
        }

        [WebMethod]
        public static Result RunUsrCodeAJAX(string code)
        {
            var result = CSharpRunner.CompileAndRun(code, 3000);
            if (result.IsError)
            {
                return new Result { IsPassed = false, Message = "Error: \n" + result.ErrorMessage };
            }
            else
            {
                return new Result { IsPassed = true, Message = (result.Outputs != null && result.Outputs.Count() > 0)
                                       ? result.Outputs[0]
                                       : "Execution completed without an output"
                };
            }
        }
    }
}