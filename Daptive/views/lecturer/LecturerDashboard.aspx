<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LecturerDashboard.aspx.cs" Inherits="Daptive.views.lecturer.LecturerDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Lecturer Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Mono:wght@300;400;500&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="../../styles/dashboard.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="shell">
          <!-- ── TOP BAR ── -->
          <header class="topbar">
            <div class="topbar-brand">
              <div class="triangle-wrap">
                <svg
                  viewBox="0 0 120 110"
                  xmlns="http://www.w3.org/2000/svg"
                  class="triangle-svg"
                >
                  <g stroke="#D4AF37" stroke-width="1.5" fill="none">
                    <polygon points="60,6 114,104 6,104" />
                    <polygon points="60,22 102,96 18,96" />
                    <polygon points="60,38 90,88 30,88" />
                    <polygon points="60,54 78,80 42,80" />
                    <line x1="60" y1="6" x2="60" y2="76" />
                    <line x1="60" y1="6" x2="36" y2="84" />
                    <line x1="60" y1="6" x2="84" y2="84" />
                  </g>
                </svg>
              </div>
              <span class="brand">CodeDaptive</span>
            </div>

            <div class="topbar-right">
              <div class="topbar-user">
                <div class="avatar">LC</div>
                <span>Lecturer</span>
              </div>
              <asp:Button ID="btnSignout" runat="server" class="btn-signout" OnClick="btnsignout_click" style="margin-left: auto" Text="Logout"></asp:Button>
            </div>
          </header>

          <!-- ── SIDEBAR ── -->
          <aside class="sidebar">
            <span class="sidebar-section-label">Main</span>

            <a href="#" class="nav-item active">
              <span class="nav-icon">
                <svg width="14" height="14" viewBox="0 0 12 12" xmlns="http://www.w3.org/2000/svg" class="nav-icon-svg" aria-hidden="true">
                  <polygon points="6,0 12,6 6,12 0,6" fill="none" stroke="currentColor" stroke-width="1.2" />
                </svg>
              </span> Dashboard
            </a>
            <a href="CreateQuiz.aspx" class="nav-item">
              <span class="nav-icon">
                <svg width="14" height="14" viewBox="0 0 12 12" xmlns="http://www.w3.org/2000/svg" class="nav-icon-svg" aria-hidden="true">
                  <polygon points="6,0 12,6 6,12 0,6" fill="none" stroke="currentColor" stroke-width="1.2" />
                </svg>
              </span> Create Quiz
            </a>
            <a href="CreateCourse.aspx" class="nav-item">
              <span class="nav-icon">
                <svg width="14" height="14" viewBox="0 0 12 12" xmlns="http://www.w3.org/2000/svg" class="nav-icon-svg" aria-hidden="true">
                  <polygon points="6,0 12,6 6,12 0,6" fill="none" stroke="currentColor" stroke-width="1.2" />
                </svg>
              </span> Create Course
            </a>
            <a href="ManageQuizzes.aspx" class="nav-item">
              <span class="nav-icon">
                <svg width="14" height="14" viewBox="0 0 12 12" xmlns="http://www.w3.org/2000/svg" class="nav-icon-svg" aria-hidden="true">
                  <polygon points="6,0 12,6 6,12 0,6" fill="none" stroke="currentColor" stroke-width="1.2" />
                </svg>
              </span> Manage Quizzes
            </a>

            <span class="sidebar-section-label">Analytics</span>

            <a href="StudentResults.aspx" class="nav-item">
              <span class="nav-icon">◈</span> Student Progress
            </a>
            <a href="QuizResults.aspx" class="nav-item">
              <span class="nav-icon">◈</span> Quiz Results
            </a>

            <div class="sidebar-footer">© 2025 CodeDaptive</div>
          </aside>

          <!-- ── MAIN CONTENT ── -->
          <main class="main">
            <div class="page-header">
              <p class="page-eyebrow">Lecturer Portal</p>
              <h1 class="page-title">Dashboard Overview</h1>
            </div>

            <!-- Stat Cards -->
            <div class="stat-grid">
              <div class="stat-card">
                <span class="stat-label">Total Students</span>
                <span class="stat-value" id="totalStudents" runat="server">--</span>
                <span class="stat-sub">Active learners</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Quizzes Created</span>
                <span class="stat-value" id="quizzesCreated" runat="server">--</span>
                <span class="stat-sub">C# exercises</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Avg Completion</span>
                <span class="stat-value" id="avgCompletion" runat="server">--</span>
                <span class="stat-sub">Quiz attempts</span>
              </div>
              <div class="stat-card">
                <span class="stat-label">Avg Score</span>
                <span class="stat-value" id="avgScore" runat="server">--</span>
                <span class="stat-sub">Across all quizzes</span>
              </div>
            </div>

            <!-- Two-column layout -->
            <div class="content-grid">
              <!-- Quick Actions -->
              <div class="panel">
                <div class="panel-header">
                  <span class="panel-title">Quick Actions</span>
                </div>
                <div class="course-list">
                  <div class="course-item">
                    <div class="course-icon">+Q</div>
                    <div class="course-info">
                      <div class="course-name">Create New Quiz</div>
                      <div class="course-meta">
                        Add coding challenges for students
                      </div>
                    </div>
                  </div>

                  <div class="course-item">
                    <div class="course-icon">+C</div>
                    <div class="course-info">
                      <div class="course-name">Create New Course</div>
                      <div class="course-meta">Build structured learning paths</div>
                    </div>
                  </div>

                  <div class="course-item">
                    <div class="course-icon">📊</div>
                    <div class="course-info">
                      <div class="course-name">View Student Progress</div>
                      <div class="course-meta">Track quiz completion & scores</div>
                    </div>
                  </div>

                  <div class="course-item">
                    <div class="course-icon">⚙</div>
                    <div class="course-info">
                      <div class="course-name">Manage Quizzes</div>
                      <div class="course-meta">Edit or delete existing quizzes</div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Recent Student Activity -->
              <div class="panel">
                <div class="panel-header">
                  <span class="panel-title">Recent Activity</span>
                </div>
                <div class="activity-list">
                  <asp:Repeater ID="rptRecentActivity" runat="server">
                    <ItemTemplate>
                      <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                          <div class="activity-text">
                            <strong><%# Eval("FullName") %></strong> <%# Eval("ActionText") %>
                          </div>
                        </div>
                      </div>
                    </ItemTemplate>
                  </asp:Repeater>
                  <div class="activity-item" id="noRecentActivity" runat="server" visible="false">No recent activity available.</div>
                </div>
              </div>
            </div>

            
          </main>
        </div>
        
    </form>
</body>
</html>
