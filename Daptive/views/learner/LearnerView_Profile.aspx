<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearnerView_Profile.aspx.cs" Inherits="Daptive.views.learner.LearnerView_Profile" %>
<%@ Register Src="~/views/learner/logo.ascx" TagPrefix="custom" TagName="Logo" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="~/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/dashboard.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/profile.css" runat="server"/>
    <title>CodeDaptive - My Profile</title>
</head>
<body>
    <script src="../../scripts/learner/profile.js"></script>
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
            <div class="sidebar">
                <ul>
                    <li><a href="LearnerView_Dashboard.aspx">Dashboard Overview</a></li>
                    <li><a href="LearnerView_Courses.aspx">Courses</a></li>
                    <li><a href="LearnerView_Assessments.aspx">Assessments</a></li>
                    <li><a href="LearnerView_Forum.aspx">Forum</a></li>
                    <li><a href="LearnerView_Profile.aspx" class="active">Profile</a></li>
                </ul>
            </div>

            <div class="main-content">
                <div class="page-header">
                    <h2>My Profile</h2>
                    <p>Manage your personal information and account settings.</p>
                </div>

                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert-msg"></asp:Label>

                <div class="content-block profile-form-block">
                    <div class="block-header">
                        <h3>Account Details</h3>
                        <span class="block-badge">Editable</span>
                    </div>
                    
                    <div class="block-body">
                        <div class="form-grid">
                            <div class="form-group">
                                <label>User ID</label>
                                <asp:TextBox ID="txtUserId" runat="server" CssClass="form-control readonly-input" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>Role</label>
                                <asp:TextBox ID="txtRole" runat="server" CssClass="form-control readonly-input" ReadOnly="true"></asp:TextBox>
                            </div>

                            <div class="form-group full-width">
                                <label>Username</label>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control editable-target" required="true"></asp:TextBox>
                            </div>
                            <div class="form-group full-width">
                                <label>Full Name</label>
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control editable-target"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control editable-target" TextMode="Email" required="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>Password</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control editable-target" TextMode="Password" required="true"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" id="btnEditProfile" class="btn-action-primary" onclick="showAuth()">Edit Profile</button>
                            <asp:Button ID="btnSaveChanges" runat="server" ClientIDMode="Static" UseSubmitBehavior="false" Text="Save Changes" CssClass="btn-action-primary" style="display:none;" OnClick="btnSaveChanges_Click"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="authModal" class="modal-overlay" style="display: none">
            <div class="modal-content">
                <h3>Authentication Required</h3>
                <p>Please enter your current password to edit your profile.</p>

                <input type="password" id="txtAuthPassword" class="form-control" placeholder="Current Password" required="required" />
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="hideAuth()">Cancel</button>
                    <button type="button" class="btn-confirm" onclick="validateAuth()">Authenticate</button>
                </div>
            </div>
        </div>
    </form>
</body>
</html>