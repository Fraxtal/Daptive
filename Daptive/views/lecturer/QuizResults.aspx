<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuizResults.aspx.cs" Inherits="Daptive.views.lecturer.QuizResults" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive 	6 Quiz Results</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Mono:wght@300;400;500&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="../../styles/dashboard.css" />
    <link rel="stylesheet" href="../../styles/lecturer/managequizzes.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="shell">
            <header class="topbar">
                <div class="topbar-brand"><span class="brand">CodeDaptive</span></div>
                <div class="topbar-right"><div class="topbar-user"><div class="avatar">LC</div><span>Lecturer</span></div></div>
            </header>

            <aside class="sidebar">
                <span class="sidebar-section-label">Main</span>
                <a href="LecturerDashboard.aspx" class="nav-item">Dashboard</a>
                <a href="CreateQuiz.aspx" class="nav-item">Create Quiz</a>
                <a href="CreateCourse.aspx" class="nav-item">Create Course</a>
                <a href="ManageQuizzes.aspx" class="nav-item">Manage Quizzes</a>
                <span class="sidebar-section-label">Analytics</span>
                <a href="#" class="nav-item active">Quiz Results</a>
                <div class="sidebar-footer">© 2025 CodeDaptive</div>
            </aside>

            <main class="main">
                <div class="page-header">
                    <p class="page-eyebrow">Lecturer Portal</p>
                    <h1 class="page-title">Quiz Results</h1>
                </div>

                <div class="panel">
                    <div class="panel-header"><span class="panel-title">Completed Quizzes</span></div>
                    <p class="section-hint">List of quizzes completed by learners (ascending).</p>

                    <asp:GridView runat="server" ID="gvResults" CssClass="table" AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField DataField="QuizId" HeaderText="#" />
                            <asp:BoundField DataField="Quiz" HeaderText="Quiz" />
                            <asp:BoundField DataField="Description" HeaderText="Description" />
                            <asp:BoundField DataField="CompletedOn" HeaderText="Completed On" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </main>
        </div>
    </form>
</body>
</html>
