<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="Daptive.Admin.Courses" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Courses</title>
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
                    <a href="Courses.aspx" class="nav-item active">
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

            <!-- MAIN -->
            <div class="main-area">

                <header class="topbar">
                    <div class="topbar-left">
                        <div class="page-title">Courses</div>
                        <div class="page-breadcrumb">Admin / Courses</div>
                    </div>
                </header>

                <main class="page-content">

                    <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false" />
                    <asp:Label ID="lblError"   runat="server" CssClass="alert alert-error"   Visible="false" />

                    <!-- Courses Table -->
                    <div class="card" style="margin-bottom:32px;">
                        <div class="card-header">
                            <span class="card-title">
                                All courses
                                <span style="font-weight:400; color:var(--text-light); font-size:12px; margin-left:8px;">
                                    (<asp:Literal ID="litCourseCount" runat="server" Text="0" /> total)
                                </span>
                            </span>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Course Name</th>
                                    <th>Topic</th>
                                    <th>Content</th>
                                    <th>Default Code</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptCourses" runat="server"
                                    OnItemCommand="rptCourses_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="font-weight:500; color:var(--text-dark);">
                                                <%# Eval("Name") %>
                                            </td>
                                            <td>
                                                <span class="badge b-lecturer"><%# Eval("TopicName") %></span>
                                            </td>
                                            <td class="td-clamp"><%# Eval("Content") %></td>
                                            <td>
                                                <code class="code-preview"><%# Eval("DefaultCode") %></code>
                                            </td>
                                            <td>
                                                <asp:LinkButton runat="server"
                                                    CommandName="DeleteCourse"
                                                    CommandArgument='<%# Eval("CourseId") %>'
                                                    CssClass="btn btn-danger btn-sm"
                                                    OnClientClick="return confirm('Delete this course? This cannot be undone.');">
                                                    Delete
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Label ID="lblNoCourses" runat="server" Visible="false"
                            Text="No courses have been added yet."
                            style="display:block; padding:20px; font-size:13px; color:var(--text-light);" />
                    </div>

                    <!-- Topics Section -->
                    <div style="margin-bottom:16px;">
                        <div style="font-family:'DM Serif Display',serif; font-size:18px; color:var(--text-dark);">Topics</div>
                        <div style="font-size:11px; color:var(--text-light); font-family:'DM Mono',monospace; margin-top:2px;">
                            Categories that group courses together
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <span class="card-title">
                                All topics
                                <span style="font-weight:400; color:var(--text-light); font-size:12px; margin-left:8px;">
                                    (<asp:Literal ID="litTopicCount" runat="server" Text="0" /> total)
                                </span>
                            </span>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Topic Name</th>
                                    <th>Description</th>
                                    <th>Courses</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptTopics" runat="server"
                                    OnItemCommand="rptTopics_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="font-weight:500; color:var(--text-dark);">
                                                <%# Eval("Topic") %>
                                            </td>
                                            <td style="color:var(--text-light);">
                                                <%# Eval("Description") %>
                                            </td>
                                            <td>
                                                <span class="badge b-student">
                                                    <%# Eval("CourseCount") %> course(s)
                                                </span>
                                            </td>
                                            <td>
                                                <asp:LinkButton runat="server"
                                                    CommandName="DeleteTopic"
                                                    CommandArgument='<%# Eval("TopicId") %>'
                                                    CssClass="btn btn-danger btn-sm"
                                                    OnClientClick="return confirm('Delete this topic? Courses under it will lose their topic.');">
                                                    Delete
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Label ID="lblNoTopics" runat="server" Visible="false"
                            Text="No topics have been added yet."
                            style="display:block; padding:20px; font-size:13px; color:var(--text-light);" />
                    </div>

                </main>
            </div>
        </div>
    </form>

    <style>
        .td-clamp {
            max-width: 240px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            color: var(--text-light);
            font-size: 12px;
        }
        .code-preview {
            font-family: 'DM Mono', monospace;
            font-size: 11px;
            color: var(--accent);
            background: var(--success-bg);
            padding: 2px 6px;
            border-radius: 4px;
            display: inline-block;
            max-width: 160px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            vertical-align: middle;
        }
        .alert { display:block; padding:12px 16px; border-radius:8px; font-size:13px; margin-bottom:20px; }
        .alert-success { background:var(--success-bg); color:var(--success); border:0.5px solid #b8d4c2; }
        .alert-error   { background:var(--error-bg);   color:var(--error);   border:0.5px solid var(--error-border); }
    </style>
</body>
</html>

