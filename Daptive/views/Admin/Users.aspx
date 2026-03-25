<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="Daptive.Admin.Users" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Manage Users</title>
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
                    <a href="Users.aspx" class="nav-item active">
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
                        <div class="page-title">Users</div>
                        <div class="page-breadcrumb">Admin / Manage Users</div>
                    </div>
                    <div class="topbar-actions">
                        <asp:Button ID="btnShowAdd" runat="server" Text="+ Add User"
                            CssClass="btn btn-primary"
                            OnClick="btnShowAdd_Click" />
                    </div>
                </header>

                <main class="page-content">

                    <!-- Alert messages -->
                    <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false" />
                    <asp:Label ID="lblError"   runat="server" CssClass="alert alert-error"   Visible="false" />

                    <!-- ── Add / Edit User Panel ──────────────── -->
                    <asp:Panel ID="pnlForm" runat="server" Visible="false" CssClass="card" style="margin-bottom: 24px;">
                        <div class="card-header">
                            <span class="card-title">
                                <asp:Literal ID="litFormTitle" runat="server" Text="Add New User" />
                            </span>
                            <asp:LinkButton ID="btnCancelForm" runat="server" CssClass="card-link"
                                Text="Cancel" OnClick="btnCancelForm_Click" />
                        </div>
                        <div class="card-body">
                            <asp:HiddenField ID="hfEditUserID" runat="server" Value="0" />

                            <div class="form-grid">
                                <div class="form-group">
                                    <label class="form-label">Full Name</label>
                                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-input" placeholder="Full name" />
                                    <asp:RequiredFieldValidator runat="server"
                                        ControlToValidate="txtFullName"
                                        ErrorMessage="Full name is required."
                                        CssClass="val-error" Display="Dynamic"
                                        ValidationGroup="UserForm" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Username</label>
                                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-input" placeholder="Username" />
                                    <asp:RequiredFieldValidator runat="server"
                                        ControlToValidate="txtUsername"
                                        ErrorMessage="Username is required."
                                        CssClass="val-error" Display="Dynamic"
                                        ValidationGroup="UserForm" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Email</label>
                                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-input" placeholder="email@example.com" />
                                    <asp:RequiredFieldValidator runat="server"
                                        ControlToValidate="txtEmail"
                                        ErrorMessage="Email is required."
                                        CssClass="val-error" Display="Dynamic"
                                        ValidationGroup="UserForm" />
                                </div>
                                <div class="form-group">
                                    <label class="form-label">Role</label>
                                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-input">
                                        <asp:ListItem Text="Student"  Value="Student"  />
                                        <asp:ListItem Text="Lecturer" Value="Lecturer" />
                                        <asp:ListItem Text="Admin"    Value="admin"    />
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <label class="form-label">
                                        Password
                                        <asp:Literal ID="litPasswordNote" runat="server"
                                            Text=" <span style='font-weight:400; color:var(--text-light);'>(leave blank to keep current)</span>" />
                                    </label>
                                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-input" placeholder="Min. 8 characters" />
                                </div>
                            </div>

                            <asp:Button ID="btnSaveUser" runat="server" Text="Save User"
                                CssClass="btn btn-primary"
                                OnClick="btnSaveUser_Click"
                                ValidationGroup="UserForm"
                                style="margin-top: 16px;" />
                        </div>
                    </asp:Panel>

                    <!-- ── Filter Bar ─────────────────────────── -->
                    <div class="card" style="margin-bottom: 24px;">
                        <div class="card-body" style="padding: 14px 20px;">
                            <div class="filter-bar">
                                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-input"
                                    placeholder="Search by name, username or email..."
                                    style="flex:1; max-width: 340px;" />
                                <asp:DropDownList ID="ddlFilterRole" runat="server" CssClass="form-input" style="width:140px;">
                                    <asp:ListItem Text="All Roles"  Value=""         />
                                    <asp:ListItem Text="Student"    Value="Student"  />
                                    <asp:ListItem Text="Lecturer"   Value="Lecturer" />
                                    <asp:ListItem Text="Admin"      Value="admin"    />
                                </asp:DropDownList>
                                <asp:Button ID="btnFilter" runat="server" Text="Search"
                                    CssClass="btn btn-outline" OnClick="btnFilter_Click" />
                                <asp:Button ID="btnReset"  runat="server" Text="Reset"
                                    CssClass="btn btn-outline" OnClick="btnReset_Click" />
                            </div>
                        </div>
                    </div>

                    <!-- ── Users Table ────────────────────────── -->
                    <div class="card">
                        <div class="card-header">
                            <span class="card-title">
                                All users
                                <span style="font-weight:400; color:var(--text-light); font-size:12px; margin-left:8px;">
                                    (<asp:Literal ID="litUserCount" runat="server" Text="0" /> total)
                                </span>
                            </span>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptUsers" runat="server"
                                    OnItemCommand="rptUsers_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <div class="user-cell">
                                                    <div class="avatar <%# Eval("AvatarClass") %>">
                                                        <%# Eval("Initials") %>
                                                    </div>
                                                    <%# Eval("FullName") %>
                                                </div>
                                            </td>
                                            <td style="color:var(--text-light); font-family:'DM Mono',monospace; font-size:12px;">
                                                <%# Eval("Username") %>
                                            </td>
                                            <td><%# Eval("Email") %></td>
                                            <td>
                                                <span class="badge <%# Eval("RoleBadgeClass") %>">
                                                    <%# Eval("Role") %>
                                                </span>
                                            </td>
                                            <td>
                                                <asp:LinkButton runat="server"
                                                    CommandName="EditUser"
                                                    CommandArgument='<%# Eval("UserID") %>'
                                                    CssClass="btn btn-outline btn-sm">Edit</asp:LinkButton>
                                                <asp:LinkButton runat="server"
                                                    CommandName="DeleteUser"
                                                    CommandArgument='<%# Eval("UserID") %>'
                                                    CssClass="btn btn-danger btn-sm"
                                                    OnClientClick="return confirm('Delete this user? This cannot be undone.');">Delete</asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Label ID="lblNoUsers" runat="server" Visible="false"
                            Text="No users found."
                            style="display:block; padding:20px; font-size:13px; color:var(--text-light);" />
                    </div>

                </main>
            </div>
        </div>
    </form>

    <style>
        .filter-bar { display:flex; align-items:center; gap:10px; flex-wrap:wrap; }
        .form-grid  { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        .form-group { display:flex; flex-direction:column; gap:6px; }
        .form-label { font-size:12px; font-weight:500; color:var(--text-mid); }
        .form-input { padding:9px 12px; border:0.5px solid var(--border); border-radius:6px;
                      font-size:13px; font-family:'DM Sans',sans-serif; color:var(--text-dark);
                      background:#fff; outline:none; width:100%; }
        .form-input:focus { border-color:var(--accent); box-shadow:0 0 0 3px rgba(45,74,62,0.08); }
        .val-error  { color:var(--error); font-size:11px; }
        .alert      { display:block; padding:12px 16px; border-radius:8px;
                      font-size:13px; margin-bottom:20px; }
        .alert-success { background:var(--success-bg); color:var(--success); border:0.5px solid #b8d4c2; }
        .alert-error   { background:var(--error-bg);   color:var(--error);   border:0.5px solid var(--error-border); }
        @media(max-width:640px) { .form-grid { grid-template-columns:1fr; } }
    </style>
</body>
</html>
