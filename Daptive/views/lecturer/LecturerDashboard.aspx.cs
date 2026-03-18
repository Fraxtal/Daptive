using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Daptive.views.lecturer
{
    public partial class LecturerDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnPublish_Click(object sender, EventArgs e)
        {
            // Read values from form fields (use Request to avoid missing control references)
            string TopicName = Request.Form["topicName"] ?? string.Empty;
            string TopicDesc = Request.Form["topicDescription"] ?? string.Empty;

            // Example: Save to database
            SaveTopic(TopicName, TopicDesc);

            // You would normally also receive lesson data via AJAX or hidden fields
        }

        private void SaveTopic(string name, string desc)
        {
            // Example only (replace with real DB logic)
            System.Diagnostics.Debug.WriteLine($"Topic: {name}");
            System.Diagnostics.Debug.WriteLine($"Description: {desc}");
        }
    }
}