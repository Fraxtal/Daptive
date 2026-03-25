<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Content.aspx.cs" Inherits="Daptive.Admin.Content" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Content</title>
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
                    <a href="Content.aspx" class="nav-item active">
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
                        <div class="page-title">Content</div>
                        <div class="page-breadcrumb">Admin / Questions &amp; Test Cases</div>
                    </div>
                </header>

                <main class="page-content">

                    <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false" />
                    <asp:Label ID="lblError"   runat="server" CssClass="alert alert-error"   Visible="false" />

                    <!-- ADD QUESTION FORM -->
                    <div class="card" style="margin-bottom:28px;">
                        <div class="card-header">
                            <span class="card-title">Add a question</span>
                        </div>
                        <div class="card-body">
                            <div class="form-group" style="margin-bottom:14px;">
                                <label class="form-label">Question text <span class="req">*</span></label>
                                <asp:TextBox ID="txtQuestion" runat="server"
                                    CssClass="form-input form-textarea"
                                    TextMode="MultiLine" Rows="3"
                                    placeholder="Describe what the student must write code to solve…" />
                            </div>
                            <div style="display:flex; justify-content:flex-end;">
                                <asp:Button ID="btnAddQuestion" runat="server" Text="Add question"
                                    CssClass="btn btn-primary" OnClick="btnAddQuestion_Click" />
                            </div>
                        </div>
                    </div>

                    <!-- QUESTIONS TABLE -->
                    <div class="card" style="margin-bottom:32px;">
                        <div class="card-header">
                            <span class="card-title">
                                Questions
                                <span style="font-weight:400; color:var(--text-light); font-size:12px; margin-left:8px;">
                                    (<asp:Literal ID="litQuestionCount" runat="server" Text="0" /> total)
                                </span>
                            </span>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Question</th>
                                    <th>Test Cases</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptQuestions" runat="server"
                                    OnItemCommand="rptQuestions_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="font-family:'DM Mono',monospace; font-size:11px; color:var(--text-light); width:40px;">
                                                <%# Eval("QuestionId") %>
                                            </td>
                                            <td style="color:var(--text-dark);">
                                                <%# Eval("Question") %>
                                            </td>
                                            <td>
                                                <span class="badge b-lecturer">
                                                    <%# Eval("TestCaseCount") %> case(s)
                                                </span>
                                            </td>
                                            <td>
                                                <asp:LinkButton runat="server"
                                                    CommandName="DeleteQuestion"
                                                    CommandArgument='<%# Eval("QuestionId") %>'
                                                    CssClass="btn btn-danger btn-sm"
                                                    OnClientClick="return confirm('Delete this question and all its test cases?');">
                                                    Delete
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Label ID="lblNoQuestions" runat="server" Visible="false"
                            Text="No questions have been added yet."
                            style="display:block; padding:20px; font-size:13px; color:var(--text-light);" />
                    </div>

                    <!-- ADD TEST CASE FORM -->
                    <div style="margin-bottom:16px;">
                        <div style="font-family:'DM Serif Display',serif; font-size:18px; color:var(--text-dark);">
                            Test Cases
                        </div>
                        <div style="font-size:11px; color:var(--text-light); font-family:'DM Mono',monospace; margin-top:2px;">
                            Input/output pairs used to validate student code submissions
                        </div>
                    </div>

                    <div class="card" style="margin-bottom:28px;">
                        <div class="card-header">
                            <span class="card-title">Add a test case</span>
                        </div>
                        <div class="card-body">
                            <div class="form-grid">

                                <div class="form-group form-full">
                                    <label class="form-label">Question <span class="req">*</span></label>
                                    <asp:DropDownList ID="ddlTestCaseQuestion" runat="server" CssClass="form-input" />
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Test case input <span class="req">*</span></label>
                                    <asp:TextBox ID="txtTestCase" runat="server"
                                        CssClass="form-input form-code"
                                        TextMode="MultiLine" Rows="3"
                                        placeholder="e.g. add(2, 3)" />
                                </div>

                                <div class="form-group">
                                    <label class="form-label">Expected output <span class="req">*</span></label>
                                    <asp:TextBox ID="txtExpectedResult" runat="server"
                                        CssClass="form-input form-code"
                                        TextMode="MultiLine" Rows="3"
                                        placeholder="e.g. 5" />
                                </div>

                            </div>
                            <div style="margin-top:16px; display:flex; justify-content:flex-end;">
                                <asp:Button ID="btnAddTestCase" runat="server" Text="Add test case"
                                    CssClass="btn btn-primary" OnClick="btnAddTestCase_Click" />
                            </div>
                        </div>
                    </div>

                    <!-- TEST CASES TABLE -->
                    <div class="card">
                        <div class="card-header">
                            <span class="card-title">
                                All test cases
                                <span style="font-weight:400; color:var(--text-light); font-size:12px; margin-left:8px;">
                                    (<asp:Literal ID="litTestCaseCount" runat="server" Text="0" /> total)
                                </span>
                            </span>
                        </div>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Question</th>
                                    <th>Test Case (Input)</th>
                                    <th>Expected Result</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptTestCases" runat="server"
                                    OnItemCommand="rptTestCases_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="font-family:'DM Mono',monospace; font-size:11px; color:var(--text-light); width:40px;">
                                                <%# Eval("TestCaseId") %>
                                            </td>
                                            <td style="color:var(--text-mid); font-size:12px; max-width:200px;">
                                                <%# Eval("QuestionText") %>
                                            </td>
                                            <td>
                                                <code class="code-preview"><%# Eval("TestCase") %></code>
                                            </td>
                                            <td>
                                                <code class="code-preview expected"><%# Eval("ExpectedResult") %></code>
                                            </td>
                                            <td>
                                                <asp:LinkButton runat="server"
                                                    CommandName="DeleteTestCase"
                                                    CommandArgument='<%# Eval("TestCaseId") %>'
                                                    CssClass="btn btn-danger btn-sm"
                                                    OnClientClick="return confirm('Delete this test case?');">
                                                    Delete
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Label ID="lblNoTestCases" runat="server" Visible="false"
                            Text="No test cases have been added yet."
                            style="display:block; padding:20px; font-size:13px; color:var(--text-light);" />
                    </div>

                </main>
            </div>
        </div>
    </form>

    <style>
        /* Form layout */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px 20px;
        }
        .form-full  { grid-column: 1 / -1; }
        .form-group { display: flex; flex-direction: column; gap: 5px; }
        .form-label {
            font-family: 'DM Mono', monospace;
            font-size: 10px;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--text-light);
        }
        .req { color: var(--error); }
        .form-input {
            padding: 8px 11px;
            font-size: 13px;
            font-family: 'DM Sans', sans-serif;
            background: var(--bg-white);
            border: 0.5px solid var(--border);
            border-radius: 6px;
            color: var(--text-dark);
            transition: border-color 0.15s, box-shadow 0.15s;
            width: 100%;
        }
        .form-input:focus {
            outline: none;
            border-color: var(--accent-light);
            box-shadow: 0 0 0 3px rgba(45,74,62,0.08);
        }
        .form-textarea { resize: vertical; }
        .form-code {
            font-family: 'DM Mono', monospace;
            font-size: 12px;
            resize: vertical;
        }
        select.form-input { cursor: pointer; }

        /* Table helpers */
        .code-preview {
            font-family: 'DM Mono', monospace;
            font-size: 11px;
            color: var(--accent);
            background: var(--success-bg);
            padding: 2px 8px;
            border-radius: 4px;
            display: inline-block;
            max-width: 180px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            vertical-align: middle;
        }
        .code-preview.expected {
            color: var(--blue);
            background: var(--blue-bg);
        }
        .alert { display:block; padding:12px 16px; border-radius:8px; font-size:13px; margin-bottom:20px; }
        .alert-success { background:var(--success-bg); color:var(--success); border:0.5px solid #b8d4c2; }
        .alert-error   { background:var(--error-bg);   color:var(--error);   border:0.5px solid var(--error-border); }
    </style>
</body>
</html>
