<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearnerView_Assessments.aspx.cs" Inherits="Daptive.views.LearnerView_Assessments" %>
<%@ Register Src="~/views/learner/logo.ascx" TagPrefix="custom" TagName="Logo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <link rel="stylesheet" href="~/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/learner.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/assessment.css" runat="server"/>
    <title></title>
</head>
<body>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.41.0/min/vs/loader.min.js"></script>
    <script src="../../scripts/learner/learner.js"></script>
    <script src="../../scripts/learner/assessment.js"></script>
    <form id="form1" runat="server">
        <div>
            <div class="top-bar">
                <div class="logo-container">
                    <custom:Logo runat="server" ID="MainBrandLogo" />
                </div>
                <asp:Button ID="btnSignout" runat="server" class="btn-signout" UseSubmitBehavior="false" OnClick="btnsignout_click" style="margin-left: auto" Text="Logout"></asp:Button>
            </div>
            <div id="err-container"></div>
            <div class="layout-container">
                 <div class="sidebar">
                     <ul>
                         <li><a href="LearnerView_Dashboard.aspx">Dashboard Overview</a></li>
                         <li><a href="LearnerView_Courses.aspx">Courses</a></li>
                         <li><a href="LearnerView_Assessments.aspx" class="active">Assessments</a></li>
                         <li><a href="LearnerView_Forum.aspx">Forum</a></li>
                         <li><a href="LearnerView_Profile.aspx">Profile</a></li>
                     </ul>
                 </div>
                <div class="main-content">
                    <h1>Quizzes</h1>
                    <br />
                    <asp:Repeater ID="rptAssessment" runat="server">
                        <ItemTemplate>
                            <div class="row-item">
                                <div class="row-header" onclick="toggleFocusMode(this)">
                                    <div class="flex-wrapper">
                                        <div class="content-left" style="flex: 1">
                                            <span><%# Eval("Question") %></span>
                                        </div>
                                        <div class="content-right" style="flex: 0 0 25%">
                                            <span id="score-<%# Eval("QuizId") %>">Highest Score: <%# Eval("Score", "{0:F0}") %>%</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="row-content">
                                    <div class="flex-wrapper">
                                        <div class="content-left">
                                            <asp:Literal ID="litContent" runat="server" Text='<%# Eval("Description") %>'></asp:Literal>
                                        </div>
                                        <div class="content-right">
                                            <h3>Your solution</h3>

                                            <div class="section-container" data-quizid="<%# Eval("QuizId") %>">
                                                <div class="monaco-container"></div>
                                                <textarea class="hidden-textbox"
                                                    style="display: none;">
    public class Program
    {
        public static void Main()
        {
            // Your code here
            //Output to console
            //Console.WriteLine();
        }
    }
                                                </textarea>

                                                <button type="button" class="btn-run" 
                                                    onclick="executeCodeAJAX(this)">
                                                    ▶ Execute
                                                </button>

                                                <h3>Terminal Output:</h3>
                                                <div class="output-box">
                                                    <asp:Literal ID="litOutput" runat="server"></asp:Literal>
                                                </div>
                                            </div>
                                        </div>
                                    </div>       
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
