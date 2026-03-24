<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearnerView_Courses.aspx.cs" Inherits="Daptive.views.LearnerView_Courses" %>
<%@ Register Src="~/views/learner/logo.ascx" TagPrefix="custom" TagName="Logo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="~/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/learner.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/course.css" runat="server"/>
    <title>CodeDaptive</title>
</head>
<body>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.41.0/min/vs/loader.min.js"></script>
    <script src="../../scripts/learner/learner.js"></script>
    <script src="../../scripts/learner/course.js"></script>
    <form id="form1" runat="server">
        <div class="top-bar">
            <div class="logo-container">
                <custom:Logo runat="server" ID="MainBrandLogo" />
            </div>
            <asp:Button ID="btnSignout" runat="server" class="btn-signout" UseSubmitBehavior="false" OnClick="btnsignout_click" style="margin-left: auto" Text="Logout"></asp:Button>
        </div>
        <div id="err-container"></div>
        <div class="layout-container">
            <div class="sidebar" id="menu-sidebar">
                <div class="sidebar-content">
                    <ul>
                        <li><a href="LearnerView_Dashboard.aspx">Dashboard Overview</a></li>
                        <li><a href="LearnerView_Courses.aspx" class="active">Courses</a></li>
                        <li><a href="LearnerView_Assessments.aspx">Assessments</a></li>
                        <li><a href="LearnerView_Forum.aspx">Forum</a></li>
                        <li><a href="LearnerView_Profile.aspx">Profile</a></li>
                    </ul>
                </div>
                <button type="button" class="btn-menu-trigger" id="btn-menu" onclick="toggleMenuFold()">&#10094;</button>
            </div>
            <div class="topics-sidebar">
                <h2 style="font-family: 'Segoe UI', Arial, sans-serif">Topics</h2>
                <asp:Repeater ID="rptSidebar" runat="server" OnItemCommand="rptSidebar_ItemCommand">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkCourse" runat="server"
                            CommandName="LoadCourse"
                            CommandArgument='<%# Eval("Id") %>'
                            Text='<%# Eval("Name") %>'/>
                    </ItemTemplate> 
                </asp:Repeater>
            </div>
            <div class="main-content">
                <div id="Topic" runat="server">
                    <h2 id="contentTopic" runat="server" style="color: var(--accent); font-family:'Segoe UI', Arial, sans-serif">Welcome to CodeDaptive</h2>
                    <br />
                    <div class="course-text">
                        <asp:Literal id="contentTopicDesc" runat="server" Text="Nice to meet you! Get started by clicking any course on the left"></asp:Literal>
                    </div>
                </div>
                <asp:Repeater ID="rptContent" runat="server">
                    <ItemTemplate>
                        <h2><%#Eval("Name") %></h2>

                        <div class="course-text">
                            <asp:Literal ID="litContent" runat="server" Text='<%# Eval("Content") %>'></asp:Literal>
                        </div>

                        <h3>Try it yourself</h3>

                        <div class="section-container">
                            <div class="monaco-container"></div>

                            <textarea class="hidden-textbox" style="display:none;">
                                <%# HttpUtility.HtmlEncode(Eval("DefaultCode").ToString()) %>
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
                        <div class="divider">Next Section</div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </form>
</body>
</html>

<!-- Botpress embed: learner pages (excluding forum) -->
<script src="https://cdn.botpress.cloud/webchat/v3.6/inject.js"></script>
<script src="https://files.bpcontent.cloud/2026/03/19/07/20260319073610-3GSVD0WT.js" defer></script>
