<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Analytics.aspx.cs" Inherits="Daptive.views.Admin.Analytics" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Analytics</title>
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
                    <a href="Analytics.aspx" class="nav-item active">
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
                        <div class="page-title">Analytics</div>
                        <div class="page-breadcrumb">Admin / Insights</div>
                    </div>
                </header>

                <main class="page-content">

                    <!-- Total Counts Stat Cards -->
                    <div class="stat-grid" style="margin-bottom:28px;">
                        <div class="stat-card">
                            <div class="stat-label">Total Users</div>
                            <div class="stat-value">
                                <asp:Literal ID="litTotalUsers" runat="server" Text="0" />
                            </div>
                            <span class="stat-badge badge-info">All accounts</span>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">Total Courses</div>
                            <div class="stat-value">
                                <asp:Literal ID="litTotalCourses" runat="server" Text="0" />
                            </div>
                            <span class="stat-badge badge-up">Published</span>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">Total Questions</div>
                            <div class="stat-value">
                                <asp:Literal ID="litTotalQuestions" runat="server" Text="0" />
                            </div>
                            <span class="stat-badge badge-info">In question bank</span>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">Total Test Cases</div>
                            <div class="stat-value">
                                <asp:Literal ID="litTotalTestCases" runat="server" Text="0" />
                            </div>
                            <span class="stat-badge badge-up">Across all questions</span>
                        </div>
                    </div>

                    <!-- User Breakdown -->
                    <div class="two-col" style="margin-bottom:28px;">

                        <!-- Bar chart -->
                        <div class="card">
                            <div class="card-header">
                                <span class="card-title">User breakdown by role</span>
                            </div>
                            <div class="card-body">
                                <div class="breakdown-chart">
                                    <div class="breakdown-row">
                                        <div class="breakdown-label">Students</div>
                                        <div class="breakdown-track">
                                            <div class="breakdown-fill fill-green"
                                                 style="width: <asp:Literal ID="litStudentPct" runat="server" Text="0" />%"></div>
                                        </div>
                                        <div class="breakdown-val">
                                            <asp:Literal ID="litStudentCount" runat="server" Text="0" />
                                        </div>
                                    </div>
                                    <div class="breakdown-row">
                                        <div class="breakdown-label">Lecturers</div>
                                        <div class="breakdown-track">
                                            <div class="breakdown-fill fill-blue"
                                                 style="width: <asp:Literal ID="litLecturerPct" runat="server" Text="0" />%"></div>
                                        </div>
                                        <div class="breakdown-val">
                                            <asp:Literal ID="litLecturerCount" runat="server" Text="0" />
                                        </div>
                                    </div>
                                    <div class="breakdown-row">
                                        <div class="breakdown-label">Admins</div>
                                        <div class="breakdown-track">
                                            <div class="breakdown-fill fill-amber"
                                                 style="width: <asp:Literal ID="litAdminPct" runat="server" Text="0" />%"></div>
                                        </div>
                                        <div class="breakdown-val">
                                            <asp:Literal ID="litAdminCount" runat="server" Text="0" />
                                        </div>
                                    </div>
                                </div>

                                <!-- Legend -->
                                <div class="legend">
                                    <div class="legend-item">
                                        <span class="legend-dot dot-green"></span>
                                        <span>Students</span>
                                    </div>
                                    <div class="legend-item">
                                        <span class="legend-dot dot-blue"></span>
                                        <span>Lecturers</span>
                                    </div>
                                    <div class="legend-item">
                                        <span class="legend-dot dot-amber"></span>
                                        <span>Admins</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Role summary table -->
                        <div class="card">
                            <div class="card-header">
                                <span class="card-title">Role summary</span>
                            </div>
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Role</th>
                                        <th>Count</th>
                                        <th>% of total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptRoleSummary" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <span class="badge <%# Eval("BadgeClass") %>">
                                                        <%# Eval("Role") %>
                                                    </span>
                                                </td>
                                                <td style="font-family:'DM Mono',monospace; font-size:13px;">
                                                    <%# Eval("Count") %>
                                                </td>
                                                <td style="font-family:'DM Mono',monospace; font-size:13px; color:var(--text-light);">
                                                    <%# Eval("Percentage") %>%
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
                    </div>

                    <!-- Platform Summary Table -->
                    <div class="card">
                        <div class="card-header">
                            <span class="card-title">Platform summary</span>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Category</th>
                                    <th>Count</th>
                                    <th>Details</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="font-weight:500;">Users</td>
                                    <td style="font-family:'DM Mono',monospace;">
                                        <asp:Literal ID="litSummaryUsers" runat="server" Text="0" />
                                    </td>
                                    <td style="color:var(--text-light); font-size:12px;">
                                        Registered accounts across all roles
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight:500;">Courses</td>
                                    <td style="font-family:'DM Mono',monospace;">
                                        <asp:Literal ID="litSummaryCourses" runat="server" Text="0" />
                                    </td>
                                    <td style="color:var(--text-light); font-size:12px;">
                                        Courses published across
                                        <asp:Literal ID="litSummaryTopics" runat="server" Text="0" /> topic(s)
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight:500;">Questions</td>
                                    <td style="font-family:'DM Mono',monospace;">
                                        <asp:Literal ID="litSummaryQuestions" runat="server" Text="0" />
                                    </td>
                                    <td style="color:var(--text-light); font-size:12px;">
                                        Questions in the bank
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight:500;">Test Cases</td>
                                    <td style="font-family:'DM Mono',monospace;">
                                        <asp:Literal ID="litSummaryTestCases" runat="server" Text="0" />
                                    </td>
                                    <td style="color:var(--text-light); font-size:12px;">
                                        Avg
                                        <asp:Literal ID="litAvgTestCases" runat="server" Text="0" /> per question
                                    </td>
                                </tr>
                                <tr>
                                    <td style="font-weight:500;">Scores Recorded</td>
                                    <td style="font-family:'DM Mono',monospace;">
                                        <asp:Literal ID="litSummaryScores" runat="server" Text="0" />
                                    </td>
                                    <td style="color:var(--text-light); font-size:12px;">
                                        Total student submissions scored
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                </main>
            </div>
        </div>
    </form>

    <style>
        .breakdown-chart  { display:flex; flex-direction:column; gap:16px; margin-bottom:20px; }
        .breakdown-row    { display:flex; align-items:center; gap:12px; }
        .breakdown-label  { font-size:12px; color:var(--text-mid); width:64px; flex-shrink:0; }
        .breakdown-track  { flex:1; height:10px; background:rgba(0,0,0,0.06); border-radius:5px; overflow:hidden; }
        .breakdown-fill   { height:100%; border-radius:5px; transition:width 0.6s ease; min-width:2px; }
        .fill-green       { background:var(--accent); }
        .fill-blue        { background:var(--blue); }
        .fill-amber       { background:var(--amber); }
        .breakdown-val    { font-family:'DM Mono',monospace; font-size:12px; color:var(--text-mid); width:24px; text-align:right; }
        .legend           { display:flex; gap:16px; flex-wrap:wrap; }
        .legend-item      { display:flex; align-items:center; gap:6px; font-size:11px; color:var(--text-light); }
        .legend-dot       { width:8px; height:8px; border-radius:50%; flex-shrink:0; }
        .dot-green        { background:var(--accent); }
        .dot-blue         { background:var(--blue); }
        .dot-amber        { background:var(--amber); }
    </style>
</body>
</html>