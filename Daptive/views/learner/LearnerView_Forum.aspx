<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearnerView_Forum.aspx.cs" Inherits="Daptive.views.learner.LearnerView_Forum" %>
<%@ Register Src="~/views/learner/logo.ascx" TagPrefix="custom" TagName="Logo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="~/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/learner.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/forum.css" runat="server"/>
    <title>CodeDaptive</title>
</head>
<body>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.41.0/min/vs/loader.min.js"></script>
    <script src="../../scripts/learner/learner.js"></script>
    <script src="../../scripts/learner/forum.js"></script>
    <form id="form1" runat="server">
        <div class="top-bar">
            <div class="logo-container">
                <custom:Logo runat="server" ID="MainBrandLogo" />
            </div>
            <asp:Button ID="btnSignout" runat="server" class="btn-signout" UseSubmitBehavior="false" OnClick="btnsignout_click" style="margin-left: auto" Text="Logout"></asp:Button>
        </div>
        <div id="err-container"></div>
        <div id="suc-container"></div>
        <div class="layout-container">
            <div class="sidebar" id="menu-sidebar">
                <ul>
                    <li><a href="LearnerView_Dashboard.aspx">Dashboard Overview</a></li>
                    <li><a href="LearnerView_Courses.aspx">Courses</a></li>
                    <li><a href="LearnerView_Assessments.aspx">Quizzes</a></li>
                    <li><a href="LearnerView_Forum.aspx" class="active">Forum</a></li>
                    <li><a href="LearnerView_Profile.aspx">Profile</a></li>
                </ul>
            </div>
            <div class="main-content">
                <div class="header">
                    <h1>Learner Forum</h1>
                </div>
                <br />
                <div class="sub-header" style="">
                    <textarea class="search-bar" rows="1" 
                        oninput="this.style.height = ''; 
                        this.style.height = this.scrollHeight + 'px';
                        search()"
                        placeholder="Search"></textarea>
                    <button class="btn-date" type="button" onclick="dateReverse(this)">
                        Date <span class="toggle-icon" style="display: inline-block; font-weight: bold; transition: transform 0.5s ease;">&#9660;</span>
                    </button>
                    <button class="btn-new" type="button" style="margin-left: auto" onclick="showPost()">Create Post</button>
                </div>
                <br />
                <asp:Repeater ID="rptForum" runat="server">
                    <ItemTemplate>
                        <div class="row-item">
                            <div class="row-header" onclick="toggleFocusMode(this, <%# Eval("ForumId") %>)">
                                <div class="flex-wrapper">
                                    <div class="content-top" style="flex: 1">
                                        <span><%# Eval("Title") %></span>
                                    </div>
                                    <div class="content-bot" style="flex: 0 0 25%">
                                        <span><%# Eval("Author") %> <%# Eval("PostedAt", "{0:MMM dd, yyyy}") %></span>
                                    </div>
                                </div>
                            </div>
                            <div class="row-content">
                                <div class="flex-wrapper">
                                    <div style="border-bottom: 1px solid rgba(45, 74, 62, 0.65); padding: 15px;">
                                        <asp:Literal ID="litContent" runat="server" Text='<%# Eval("Content") %>'></asp:Literal>
                                    </div>
                                    <div class="comment-area" data-id="<%# Eval("ForumId") %>">
                                        <textarea class="comment" rows="1" oninput="this.style.height = ''; this.style.height = this.scrollHeight + 'px'"></textarea>
                                        <button class="btn-new" type="button" onclick="sendReply(this)">Send</button>
                                    </div>
                                    <div class="replies-container" id='replies-<%# Eval("ForumId") %>'></div>
                                </div>       
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        <div class="modal-overlay" id="post-box" style="display: none;">
            <div class="modal-content">
                <h3>Post a new discussion</h3>
                <asp:TextBox ID="txtPostTitle" runat="server" CssClass="form-control" placeholder="Title" style="padding: 8px; border: 1px solid #ccc; border-radius: 4px;" />
                <asp:TextBox ID="txtPostContent" runat="server" TextMode="MultiLine" CssClass="form-control" placeholder="Content" style="margin-top: 10px; height: 100px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; resize: vertical;" />
                <div class="modal-actions">
                    <button class="btn-confirm" type="button" onclick="sendPost()">Send</button>
                    <button class="btn-cancel" type="button" onclick="hidePost()">Cancel</button>
                </div>  
            </div>
        </div>
    </form>
</body>
</html>
