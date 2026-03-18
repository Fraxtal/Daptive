<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="Daptive.views.Admin.Reports" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Reports</title>
    <link rel="stylesheet" href="../../styles/admin.css" />
    <style>
        /* Report-specific styles */
        .report-section        { margin-bottom: 36px; }
        .report-section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }
        .report-section-title {
            font-family: 'DM Serif Display', serif;
            font-size: 17px;
            color: var(--text-dark);
        }
        .report-section-sub {
            font-size: 11px;
            color: var(--text-light);
            font-family: 'DM Mono', monospace;
            margin-top: 2px;
        }
        .btn-print {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 16px;
            font-size: 12px;
            font-family: 'DM Sans', sans-serif;
            background: var(--bg-white);
            color: var(--text-mid);
            border: 0.5px solid var(--border);
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
        }
        .btn-print:hover { background: var(--bg-ivory); }
        .score-pill {
            display: inline-block;
            font-family: 'DM Mono', monospace;
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: 500;
        }
        .score-high { background: var(--success-bg); color: var(--success); }
        .score-mid  { background: var(--amber-bg);   color: var(--amber); }
        .score-low  { background: var(--error-bg);   color: var(--error); }

        /* Print styles */
        @media print {
            .sidebar, .topbar, .btn-print, .no-print { display: none !important; }
            .main-area  { margin-left: 0 !important; }
            .page-content { padding: 0 !important; }
            .card { border: 1px solid #ccc !important; break-inside: avoid; }
            .report-section { page-break-inside: avoid; }
            body { background: #fff !important; }
        }
    </style>
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
                    <a href="Reports.aspx" class="nav-item active">
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
                        <div class="page-title">Reports</div>
                        <div class="page-breadcrumb">Admin / Insights</div>
                    </div>
                    <div class="topbar-actions no-print">
                        <button type="button" class="btn-print" onclick="window.print()">
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="6 9 6 2 18 2 18 9"/>
                                <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
                                <rect x="6" y="14" width="12" height="8"/>
                            </svg>
                            Print Report
                        </button>
                    </div>
                </header>

                <main class="page-content">

                    <!-- 1. Score Records -->
                    <div class="report-section">
                        <div class="report-section-header">
                            <div>
                                <div class="report-section-title">Score Records</div>
                                <div class="report-section-sub">
                                    Who scored what on which question —
                                    <asp:Literal ID="litScoreCount" runat="server" Text="0" /> records total
                                </div>
                            </div>
                        </div>
                        <div class="card">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Student</th>
                                        <th>Username</th>
                                        <th>Question</th>
                                        <th>Score</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptScores" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="font-family:'DM Mono',monospace; font-size:11px; color:var(--text-light);">
                                                    <%# Eval("ScoreId") %>
                                                </td>
                                                <td style="font-weight:500; color:var(--text-dark);">
                                                    <%# Eval("FullName") %>
                                                </td>
                                                <td style="font-family:'DM Mono',monospace; font-size:12px; color:var(--text-light);">
                                                    <%# Eval("Username") %>
                                                </td>
                                                <td style="max-width:280px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">
                                                    <%# Eval("Question") %>
                                                </td>
                                                <td>
                                                    <span class="score-pill <%# Eval("ScoreClass") %>">
                                                        <%# Eval("Score") %>
                                                    </span>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Label ID="lblNoScores" runat="server" Visible="false"
                                Text="No score records found."
                                style="display:block; padding:20px; font-size:13px; color:var(--text-light);" />
                        </div>
                    </div>

                    <!-- 2. User List -->
                    <div class="report-section">
                        <div class="report-section-header">
                            <div>
                                <div class="report-section-title">Registered Users</div>
                                <div class="report-section-sub">
                                    All accounts on the platform —
                                    <asp:Literal ID="litUserCount" runat="server" Text="0" /> users total
                                </div>
                            </div>
                        </div>
                        <div class="card">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Full Name</th>
                                        <th>Username</th>
                                        <th>Email</th>
                                        <th>Role</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptUsers" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="font-family:'DM Mono',monospace; font-size:11px; color:var(--text-light);">
                                                    <%# Eval("UserID") %>
                                                </td>
                                                <td style="font-weight:500; color:var(--text-dark);">
                                                    <%# Eval("FullName") %>
                                                </td>
                                                <td style="font-family:'DM Mono',monospace; font-size:12px; color:var(--text-light);">
                                                    <%# Eval("Username") %>
                                                </td>
                                                <td><%# Eval("Email") %></td>
                                                <td>
                                                    <span class="badge <%# Eval("BadgeClass") %>">
                                                        <%# Eval("Role") %>
                                                    </span>
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

                    <!-- 3. Courses & Topics -->
                    <div class="report-section">
                        <div class="report-section-header">
                            <div>
                                <div class="report-section-title">Courses &amp; Topics</div>
                                <div class="report-section-sub">
                                    All published courses grouped by topic —
                                    <asp:Literal ID="litCourseCount" runat="server" Text="0" /> courses total
                                </div>
                            </div>
                        </div>
                        <div class="card">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Course Name</th>
                                        <th>Topic</th>
                                        <th>Content Preview</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptCourses" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="font-family:'DM Mono',monospace; font-size:11px; color:var(--text-light);">
                                                    <%# Eval("CourseId") %>
                                                </td>
                                                <td style="font-weight:500; color:var(--text-dark);">
                                                    <%# Eval("Name") %>
                                                </td>
                                                <td>
                                                    <span class="badge b-lecturer"><%# Eval("TopicName") %></span>
                                                </td>
                                                <td style="color:var(--text-light); font-size:12px;
                                                           max-width:300px; overflow:hidden;
                                                           text-overflow:ellipsis; white-space:nowrap;">
                                                    <%# Eval("Content") %>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Label ID="lblNoCourses" runat="server" Visible="false"
                                Text="No courses found."
                                style="display:block; padding:20px; font-size:13px; color:var(--text-light);" />
                        </div>
                    </div>

                    <!-- 4. Questions & Test Case Counts -->
                    <div class="report-section">
                        <div class="report-section-header">
                            <div>
                                <div class="report-section-title">Questions &amp; Test Cases</div>
                                <div class="report-section-sub">
                                    All questions with their test case counts —
                                    <asp:Literal ID="litQuestionCount" runat="server" Text="0" /> questions total
                                </div>
                            </div>
                        </div>
                        <div class="card">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Question</th>
                                        <th>Test Cases</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptQuestions" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="font-family:'DM Mono',monospace; font-size:11px; color:var(--text-light);">
                                                    <%# Eval("QuestionId") %>
                                                </td>
                                                <td style="color:var(--text-dark);">
                                                    <%# Eval("Question") %>
                                                </td>
                                                <td>
                                                    <span class="badge b-student">
                                                        <%# Eval("TestCaseCount") %> case(s)
                                                    </span>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Label ID="lblNoQuestions" runat="server" Visible="false"
                                Text="No questions found."
                                style="display:block; padding:20px; font-size:13px; color:var(--text-light);" />
                        </div>
                    </div>

                </main>
            </div>
        </div>
    </form>
</body>
</html>