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

        protected void Page_Load(object sender, EventArgs e)
        {
            courses.Add(new Courses { Id = 1, TopicId = 1, Name = "Variables", Content = "Variables are containers for storing data values. In C#, there are different types of variables like int, double, char, string, and bool.", DefaultCode = "" });
            courses.Add(new Courses { Id = 2, TopicId = 1, Name = "Strings", Content = "A string is used for storing text. A string variable contains a collection of characters surrounded by double quotes.", DefaultCode = "" });
            courses.Add(new Courses { Id = 3, TopicId = 1, Name = "Operators", Content = "Operators are used to perform operations on variables and values, such as Arithmetic, Assignment, Comparison, and Logical operators.", DefaultCode = "" });
            courses.Add(new Courses { Id = 4, TopicId = 1, Name = "Booleans", Content = "In programming, you often need a data type that can only have one of two values, like YES/NO or TRUE/FALSE. C# uses the bool data type for this.", DefaultCode = "" });

            courses.Add(new Courses { Id = 5, TopicId = 2, Name = "If...Else", Content = "C# supports logical conditions from mathematics. You can use these conditions to perform different actions for different decisions using if, else if, and else statements.", DefaultCode = "" });
            courses.Add(new Courses { Id = 6, TopicId = 2, Name = "Switch", Content = "Use the switch statement to select one of many code blocks to be executed. This is often used as a cleaner alternative to long if...else if chains.", DefaultCode = "" });
            courses.Add(new Courses { Id = 7, TopicId = 2, Name = "Loops", Content = "Loops execute a block of code as long as a specified condition is reached. They save time and reduce errors. Common loops include for and while.", DefaultCode = "" });

            courses.Add(new Courses { Id = 8, TopicId = 3, Name = "Arrays", Content = "Arrays are used to store multiple values in a single variable. To declare an array, define the variable type with square brackets.", DefaultCode = "" });
            courses.Add(new Courses { Id = 9, TopicId = 3, Name = "Lists", Content = "A List is a strongly typed collection of objects that can be accessed by index. Unlike arrays, lists can dynamically grow and shrink in size.", DefaultCode = "" });
            courses.Add(new Courses { Id = 10, TopicId = 3, Name = "Dictionaries", Content = "A Dictionary is a collection of keys and values. It is used to store data in key/value pairs, providing fast data retrieval based on the keys.", DefaultCode = "" });

            topics.Add(new Topics { Id = 1, Name = "Introduction to C#", Description = "" });
            topics.Add(new Topics { Id = 2, Name = "Logic Operator", Description = "" });
            topics.Add(new Topics { Id = 3, Name = "Containers", Description = "" });

            if (!IsPostBack)
            {
                rptSidebar.DataSource = topics;
                rptSidebar.DataBind();
            }
        }

        protected void rptSidebar_ItemCommand(object sender, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "LoadCourse")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                if (id > 0)
                {
                    var courses = this.courses.Where(c => c.TopicId == id);
                    rptContent.DataSource = courses;
                    rptContent.DataBind();
                    welcomeMsg.Visible = false;
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