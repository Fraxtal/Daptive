<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="Daptive.Admin.Dashboard" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Admin Dashboard</title>
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
                    <a href="Dashboard.aspx" class="nav-item active">
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
                    <a href="../../Login.aspx" class="logout-link" onclick="return confirm('Sign out?')">Sign out</a>
                </div>
            </aside>

            <!-- MAIN CONTENT -->
            <div class="main-area">

                <header class="topbar">
                    <div class="topbar-left">
                        <div class="page-title">Dashboard</div>
                        <div class="page-breadcrumb">Admin / Overview</div>
                    </div>
                    <div class="topbar-actions">
                        <a href="Users.aspx"   class="btn btn-outline">Manage Users</a>
                        <a href="Courses.aspx" class="btn btn-primary">+ New Course</a>
                    </div>
                </header>

                <main class="page-content">

                    <!-- Stat Cards -->
                    <div class="stat-grid">
                        <div class="stat-card">
                            <div class="stat-label">Total Users</div>
                            <div class="stat-value">
                                <asp:Literal ID="litTotalUsers" runat="server" Text="0" />
                            </div>
                            <span class="stat-badge badge-info">All accounts</span>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">Students</div>
                            <div class="stat-value">
                                <asp:Literal ID="litTotalStudents" runat="server" Text="0" />
                            </div>
                            <span class="stat-badge badge-up">Registered</span>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">Lecturers</div>
                            <div class="stat-value">
                                <asp:Literal ID="litTotalLecturers" runat="server" Text="0" />
                            </div>
                            <span class="stat-badge badge-info">Active faculty</span>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">Total Courses</div>
                            <div class="stat-value">
                                <asp:Literal ID="litTotalCourses" runat="server" Text="0" />
                            </div>
                            <span class="stat-badge badge-up">Published</span>
                        </div>
                    </div>

                    <!-- Course Activity Chart -->
                    <div class="card" style="margin-bottom: 24px;">
                        <div class="card-header">
                            <span class="card-title">Course activity</span>
                            <a href="Courses.aspx" class="card-link">Manage courses →</a>
                        </div>
                        <div class="card-body">
                            <div class="bar-chart">
                                <asp:Repeater ID="rptCourseStats" runat="server">
                                    <ItemTemplate>
                                        <div class="bar-row">
                                            <div class="bar-label"><%# Eval("CourseName") %></div>
                                            <div class="bar-track">
                                                <div class="bar-fill <%# (int)Eval("SortOrder") <= 2 ? "" : "bar-fill-light" %>"
                                                     style="width: <%# Eval("BarPercent") %>%"></div>
                                            </div>
                                            <div class="bar-val"><%# Eval("ActivityCount") %></div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                                <asp:Label ID="lblNoCourses" runat="server"
                                    Text="No courses added yet."
                                    CssClass="stat-label" Visible="false"
                                    style="display:block; padding: 8px 0;" />
                            </div>
                        </div>
                    </div>

                    <!-- Recent Users Table -->
                    <div class="card">
                        <div class="card-header">
                            <span class="card-title">Recently registered users</span>
                            <a href="Users.aspx" class="card-link">View all users →</a>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptRecentUsers" runat="server">
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
                                            <td><%# Eval("Email") %></td>
                                            <td>
                                                <span class="badge <%# Eval("RoleBadgeClass") %>">
                                                    <%# Eval("Role") %>
                                                </span>
                                            </td>
                                            <td>
                                                <a href='Users.aspx?action=edit&id=<%# Eval("UserID") %>'
                                                   class="btn btn-outline btn-sm">Edit</a>
                                                <asp:LinkButton runat="server"
                                                    CommandName="DeleteUser"
                                                    CommandArgument='<%# Eval("UserID") %>'
                                                    CssClass="btn btn-danger btn-sm"
                                                    OnClientClick="return confirm('Delete this user? This cannot be undone.');"
                                                    OnCommand="BtnDeleteUserCommand"
                                                    Text="Delete" />
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Label ID="lblNoUsers" runat="server"
                            Text="No users found." Visible="false"
                            style="display:block; padding: 20px; font-size:13px; color: var(--text-light);" />
                    </div>

                </main>
            </div>
        </div>
    </form>
</body>
</html>

