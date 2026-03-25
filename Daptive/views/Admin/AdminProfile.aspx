<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminProfile.aspx.cs" Inherits="Daptive.Admin.AdminProfile" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – My Profile</title>
    <link rel="stylesheet" href="../../styles/admin.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="admin-shell">

            <!-- SIDEBAR -->
            <aside class="sidebar">
                <div class="sidebar-brand">
                    <div class="brand-logo">
                        <img src="../../resources/logo.png" alt="CodeDaptive Logo" style="width:40px; height:40px; object-fit:contain;" />
                        <span class="brand-name">CodeDaptive</span>
                    </div>
                    <div class="brand-tag">Admin Portal</div>
                </div>

                <nav class="nav-group">
                    <div class="nav-group-label">Overview</div>
                    <a href="Dashboard.aspx" class="nav-item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/>
                            <rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/>
                        </svg>
                        Dashboard
                    </a>
                </nav>

                <nav class="nav-group">
                    <div class="nav-group-label">Manage</div>
                    <a href="Users.aspx" class="nav-item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
                            <circle cx="9" cy="7" r="4"/>
                            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
                            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
                        </svg>
                        Users
                    </a>
                    <a href="Courses.aspx" class="nav-item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                            <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                        </svg>
                        Courses
                    </a>
                    <a href="Content.aspx" class="nav-item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <polyline points="14 2 14 8 20 8"/>
                            <line x1="16" y1="13" x2="8" y2="13"/>
                            <line x1="16" y1="17" x2="8" y2="17"/>
                            <line x1="10" y1="9"  x2="8" y2="9"/>
                        </svg>
                        Content
                    </a>
                </nav>

                <nav class="nav-group">
                    <div class="nav-group-label">Insights</div>
                    <a href="Analytics.aspx" class="nav-item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="18" y1="20" x2="18" y2="10"/>
                            <line x1="12" y1="20" x2="12" y2="4"/>
                            <line x1="6"  y1="20" x2="6"  y2="14"/>
                        </svg>
                        Analytics
                    </a>
                    <a href="Reports.aspx" class="nav-item">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                            <polyline points="14 2 14 8 20 8"/>
                            <line x1="12" y1="18" x2="12" y2="12"/>
                            <line x1="9"  y1="15" x2="15" y2="15"/>
                        </svg>
                        Reports
                    </a>
                </nav>

                <div class="sidebar-spacer"></div>

                <div class="sidebar-footer">
                    <a href="AdminProfile.aspx" class="admin-pill" style="text-decoration:none;">
                        <div class="admin-avatar">
                            <asp:Literal ID="litInitials" runat="server" Text="AD" />
                        </div>
                        <div class="admin-info">
                            <div class="admin-name">
                                <asp:Literal ID="litUsername" runat="server" Text="Admin" />
                            </div>
                            <div class="admin-role">Super Admin</div>
                        </div>
                    </a>
                    <asp:LinkButton ID="btnSignOut" runat="server" CssClass="logout-link"
                        OnClientClick="return confirm('Sign out?');"
                        OnClick="btnSignOut_Click">Sign out</asp:LinkButton>
                </div>
            </aside>

            <!-- MAIN -->
            <div class="main-area">

                <header class="topbar">
                    <div class="topbar-left">
                        <div class="page-title">My Profile</div>
                        <div class="page-breadcrumb">Admin / Profile</div>
                    </div>
                </header>

                <main class="page-content">

                    <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false" />
                    <asp:Label ID="lblError"   runat="server" CssClass="alert alert-error"   Visible="false" />

                    <div class="profile-layout">

                        <!-- Profile Card-->
                        <div class="card profile-card">
                            <div class="card-body" style="text-align:center; padding: 32px 24px;">
                                <div class="profile-avatar">
                                    <asp:Literal ID="litAvatarInitials" runat="server" Text="AD" />
                                </div>
                                <div class="profile-name">
                                    <asp:Literal ID="litProfileName" runat="server" Text="" />
                                </div>
                                <div class="profile-role">Super Admin</div>
                                <div class="profile-meta">
                                    <div class="profile-meta-item">
                                        <span class="profile-meta-label">Username</span>
                                        <span class="profile-meta-value">
                                            <asp:Literal ID="litProfileUsername" runat="server" Text="" />
                                        </span>
                                    </div>
                                    <div class="profile-meta-item">
                                        <span class="profile-meta-label">Email</span>
                                        <span class="profile-meta-value">
                                            <asp:Literal ID="litProfileEmail" runat="server" Text="" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Edit Form -->
                        <div class="profile-forms">

                            <!-- Update Info -->
                            <div class="card" style="margin-bottom: 20px;">
                                <div class="card-header">
                                    <span class="card-title">Personal information</span>
                                </div>
                                <div class="card-body">
                                    <div class="form-group" style="margin-bottom:16px;">
                                        <label class="form-label">Full Name</label>
                                        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-input" placeholder="Your full name" />
                                        <asp:RequiredFieldValidator runat="server"
                                            ControlToValidate="txtFullName"
                                            ErrorMessage="Full name is required."
                                            CssClass="val-error" Display="Dynamic"
                                            ValidationGroup="InfoForm" />
                                    </div>
                                    <div class="form-group" style="margin-bottom:16px;">
                                        <label class="form-label">Username</label>
                                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="Username" />
                                        <asp:RequiredFieldValidator runat="server"
                                            ControlToValidate="txtUsername"
                                            ErrorMessage="Username is required."
                                            CssClass="val-error" Display="Dynamic"
                                            ValidationGroup="InfoForm" />
                                    </div>
                                    <div class="form-group" style="margin-bottom:20px;">
                                        <label class="form-label">Email Address</label>
                                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-input" placeholder="email@example.com" />
                                        <asp:RequiredFieldValidator runat="server"
                                            ControlToValidate="txtEmail"
                                            ErrorMessage="Email is required."
                                            CssClass="val-error" Display="Dynamic"
                                            ValidationGroup="InfoForm" />
                                    </div>
                                    <asp:Button ID="btnUpdateInfo" runat="server"
                                        Text="Save Changes"
                                        CssClass="btn btn-primary"
                                        ValidationGroup="InfoForm"
                                        OnClick="btnUpdateInfo_Click" />
                                </div>
                            </div>

                            <!-- Change Password -->
                            <div class="card">
                                <div class="card-header">
                                    <span class="card-title">Change password</span>
                                </div>
                                <div class="card-body">
                                    <div class="form-group" style="margin-bottom:16px;">
                                        <label class="form-label">Current Password</label>
                                        <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="Enter current password" />
                                        <asp:RequiredFieldValidator runat="server"
                                            ControlToValidate="txtCurrentPassword"
                                            ErrorMessage="Current password is required."
                                            CssClass="val-error" Display="Dynamic"
                                            ValidationGroup="PwForm" />
                                    </div>
                                    <div class="form-group" style="margin-bottom:16px;">
                                        <label class="form-label">New Password</label>
                                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="Min. 8 characters" />
                                        <asp:RequiredFieldValidator runat="server"
                                            ControlToValidate="txtNewPassword"
                                            ErrorMessage="New password is required."
                                            CssClass="val-error" Display="Dynamic"
                                            ValidationGroup="PwForm" />
                                        <asp:RegularExpressionValidator runat="server"
                                            ControlToValidate="txtNewPassword"
                                            ValidationExpression="^.{8,}$"
                                            ErrorMessage="Password must be at least 8 characters."
                                            CssClass="val-error" Display="Dynamic"
                                            ValidationGroup="PwForm" />
                                    </div>
                                    <div class="form-group" style="margin-bottom:20px;">
                                        <label class="form-label">Confirm New Password</label>
                                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="Re-enter new password" />
                                        <asp:RequiredFieldValidator runat="server"
                                            ControlToValidate="txtConfirmPassword"
                                            ErrorMessage="Please confirm your new password."
                                            CssClass="val-error" Display="Dynamic"
                                            ValidationGroup="PwForm" />
                                        <asp:CompareValidator runat="server"
                                            ControlToValidate="txtConfirmPassword"
                                            ControlToCompare="txtNewPassword"
                                            ErrorMessage="Passwords do not match."
                                            CssClass="val-error" Display="Dynamic"
                                            ValidationGroup="PwForm" />
                                    </div>
                                    <asp:Button ID="btnChangePassword" runat="server"
                                        Text="Update Password"
                                        CssClass="btn btn-primary"
                                        ValidationGroup="PwForm"
                                        OnClick="btnChangePassword_Click" />
                                </div>
                            </div>

                        </div>
                    </div>

                </main>
            </div>
        </div>
    </form>

    <style>
        .profile-layout  { display:grid; grid-template-columns:260px 1fr; gap:24px; align-items:start; }
        .profile-avatar  { width:72px; height:72px; border-radius:50%; background:var(--gold);
                           color:var(--accent); display:flex; align-items:center; justify-content:center;
                           font-size:24px; font-weight:600; margin:0 auto 16px; }
        .profile-name    { font-family:'DM Serif Display',serif; font-size:20px; color:var(--text-dark);
                           margin-bottom:4px; }
        .profile-role    { font-family:'DM Mono',monospace; font-size:10px; letter-spacing:0.1em;
                           text-transform:uppercase; color:var(--text-light); margin-bottom:24px; }
        .profile-meta    { text-align:left; border-top:0.5px solid var(--border); padding-top:16px; }
        .profile-meta-item  { display:flex; flex-direction:column; gap:2px; margin-bottom:12px; }
        .profile-meta-label { font-size:10px; font-family:'DM Mono',monospace; letter-spacing:0.08em;
                              text-transform:uppercase; color:var(--text-light); }
        .profile-meta-value { font-size:13px; color:var(--text-dark); word-break:break-all; }
        .form-group  { display:flex; flex-direction:column; gap:6px; }
        .form-label  { font-size:12px; font-weight:500; color:var(--text-mid); }
        .form-input  { padding:9px 12px; border:0.5px solid var(--border); border-radius:6px;
                       font-size:13px; font-family:'DM Sans',sans-serif; color:var(--text-dark);
                       background:#fff; outline:none; width:100%; }
        .form-input:focus { border-color:var(--accent); box-shadow:0 0 0 3px rgba(45,74,62,0.08); }
        .val-error   { color:var(--error); font-size:11px; }
        .alert       { display:block; padding:12px 16px; border-radius:8px;
                       font-size:13px; margin-bottom:20px; }
        .alert-success { background:var(--success-bg); color:var(--success); border:0.5px solid #b8d4c2; }
        .alert-error   { background:var(--error-bg);   color:var(--error);   border:0.5px solid var(--error-border); }
        @media(max-width:768px) { .profile-layout { grid-template-columns:1fr; } }
    </style>
</body>
</html>
