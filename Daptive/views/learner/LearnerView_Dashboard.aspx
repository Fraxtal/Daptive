<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearnerView_Dashboard.aspx.cs" Inherits="Daptive.views.learner.LearnerView_Dashboard" %>
<%@ Register Src="~/views/learner/logo.ascx" TagPrefix="custom" TagName="Logo" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="~/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/dashboard.css" runat="server"/>
    <title>CodeDaptive - Dashboard</title>
</head>
<body>
    <script src="../../scripts/learner/dashboard.js"></script>
    <form id="form1" runat="server">
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
                    <li><a href="LearnerView_Dashboard.aspx" class="active">Dashboard Overview</a></li>
                    <li><a href="LearnerView_Courses.aspx">Courses</a></li>
                    <li><a href="LearnerView_Assessments.aspx">Assessments</a></li>
                    <li><a href="LearnerView_Forum.aspx">Forum</a></li>
                    <li><a href="LearnerView_Profile.aspx">Profile</a></li>
                </ul>
            </div>

            <div class="main-content">
                <div class="page-header">
                    <h2>Dashboard Overview</h2>
                    <p>Welcome back! Here is your current progress.</p>
                </div>

                <div class="dashboard-block-layout">
                    
                    <div class="content-block">
                        <div class="block-header">
                            <h3>Courses</h3>
                            <span class="block-badge">Courses</span>
                        </div>
                        <div class="block-body">
                            <div class="dashboard-list">
                                <asp:Repeater ID="rptMiniCourses" runat="server">
                                    <ItemTemplate>
                                        <div class="mini-list-item">
                                            <div class="mini-item-left" style="min-width: 50%">
                                                <div class="mini-item-text">
                                                    <h4><%# Eval("Name") %></h4>
                                                    <span class="sub-text"><%# Eval("Topic") %></span>
                                                </div>
                                            </div>
                                            <a href="LearnerView_Courses.aspx" class="btn-action-sm">View Courses</a>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Label ID="lblNoCourses" runat="server" Visible="false" CssClass="empty-msg">No active courses found.</asp:Label>
                            </div>
                        </div>
                    </div>

                    <div class="content-block">
                        <div class="block-header">
                            <h3>Quizzes</h3>
                            <span class="block-badge">Quizzes</span>
                        </div>
                        <div class="block-body">
                            <div class="dashboard-list">
                                <asp:Repeater ID="rptMiniQuizzes" runat="server">
                                    <ItemTemplate>
                                        <div class="mini-list-item">
                                            <div class="mini-item-left" style="width: 65%">
                                                <div class="mini-item-text">
                                                    <h4 class="truncate" title='<%# Eval("Question") %>'><%# Eval("Question") %></h4>
                                                </div>
                                            </div>
                                            <span class="score-text">
                                                Recent Highest: <%# Eval("UserScore", "{0:F0}") %>%
                                            </span>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Label ID="Label1" runat="server" Visible="false" CssClass="empty-msg">No upcoming quizzes.</asp:Label>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>
