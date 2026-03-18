<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs"
Inherits="Daptive.views.index" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Mono:wght@300;400;500&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="../styles/dashboard.css" />
</head>
<body>
<div class="shell">

<html xmlns="http://www.w3.org/1999/xhtml">
  <head runat="server">
    <title>Homepage</title>
    <link rel="stylesheet" href="../styles/style.css" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
      crossorigin="anonymous"
    />
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css" />
  </head>
  <body>
    <form id="form1" runat="server">
      <div class="container">
          <nav
            class="navbar navbar-expand-lg bg-body-tertiary rounded"
            aria-label="Eleventh navbar example"
          >
            <div class="container-fluid">
              <i class="bi bi-book" style="font-size: 2rem; color: cornflowerblue;"></i>
              <button
                class="navbar-toggler"
                type="button"
                data-bs-toggle="collapse"   
                data-bs-target="#navbarsExample09"
                aria-controls="navbarsExample09"
                aria-expanded="false"
                aria-label="Toggle navigation"
              >
                <span class="navbar-toggler-icon"></span>
              </button>
              <div class="collapse navbar-collapse" id="navbarsExample09">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                  <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="#">Home</a>
                  </li>
                  <li class="nav-item">
                      <a class="nav-link" aria-current="page" href="#">Learning</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" aria-current="page" href="#">Sponsors</a>
                      </li>
                </ul>
              </div>
    <!-- ── TOP BAR ── -->
    <header class="topbar">
        <div class="topbar-brand">
            <div class="triangle-wrap">
                <svg viewBox="0 0 120 110" xmlns="http://www.w3.org/2000/svg" class="triangle-svg">
                    <g stroke="#D4AF37" stroke-width="1.5" fill="none">
                        <polygon points="60,6 114,104 6,104"/>
                        <polygon points="60,22 102,96 18,96"/>
                        <polygon points="60,38 90,88 30,88"/>
                        <polygon points="60,54 78,80 42,80"/>
                        <line x1="60" y1="6" x2="60" y2="76"/>
                        <line x1="60" y1="6" x2="36" y2="84"/>
                        <line x1="60" y1="6" x2="84" y2="84"/>
                    </g>
                </svg>
            </div>
            <span class="brand">CodeDaptive</span>
        </div>

        <div class="topbar-right">
            <div class="topbar-user">
                <div class="avatar">JD</div>
                <span>John Doe</span>
            </div>
            <button class="btn-signout">Sign out</button>
        </div>
    </header>

    <!-- ── SIDEBAR ── -->
    <aside class="sidebar">
        <span class="sidebar-section-label">Main</span>

        <a href="#" class="nav-item active">
            <span class="nav-icon">◈</span> Dashboard
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">◈</span> My Courses
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">◈</span> Exercises
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">◈</span> Quizzes
        </a>

        <span class="sidebar-section-label">Progress</span>

        <a href="#" class="nav-item">
            <span class="nav-icon">◈</span> My Progress
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">◈</span> Achievements
        </a>

        <span class="sidebar-section-label">Community</span>

        <a href="#" class="nav-item">
            <span class="nav-icon">◈</span> Forum
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">◈</span> Code Reviews
        </a>

        <div class="sidebar-footer">© 2025 CodeDaptive</div>
    </aside>

    <!-- ── MAIN CONTENT ── -->
    <main class="main">

        <div class="page-header">
            <p class="page-eyebrow">Overview</p>
            <h1 class="page-title">Welcome back, John.</h1>
        </div>

        <!-- Stat Cards -->
        <div class="stat-grid">
            <div class="stat-card">
                <span class="stat-label">Courses Enrolled</span>
                <span class="stat-value">4</span>
                <span class="stat-sub">2 in progress</span>
            </div>
            <div class="stat-card">
                <span class="stat-label">Exercises Done</span>
                <span class="stat-value">38</span>
                <span class="stat-sub">+5 this week</span>
            </div>
            <div class="stat-card">
                <span class="stat-label">Quiz Score Avg</span>
                <span class="stat-value">82%</span>
                <span class="stat-sub">Across 12 quizzes</span>
            </div>
            <div class="stat-card">
                <span class="stat-label">Day Streak</span>
                <span class="stat-value">7</span>
                <span class="stat-sub">Keep it going!</span>
            </div>
        </div>

        <!-- Two-column layout -->
        <div class="content-grid">

            <!-- Active Courses -->
            <div class="panel">
                <div class="panel-header">
                    <span class="panel-title">Active Courses</span>
                    <a href="#" class="panel-action">View all</a>
                </div>
                <div class="course-list">

                    <div class="course-item">
                        <div class="course-icon">C#</div>
                        <div class="course-info">
                            <div class="course-name">C# Fundamentals</div>
                            <div class="course-meta">Module 4 of 8 · Variables &amp; Types</div>
                            <div class="progress-wrap">
                                <div class="progress-bar"><div class="progress-fill" style="width:50%"></div></div>
                                <div class="progress-label">50% complete</div>
                            </div>
                        </div>
                    </div>

                    <div class="course-item">
                        <div class="course-icon">OOP</div>
                        <div class="course-info">
                            <div class="course-name">Object-Oriented Programming</div>
                            <div class="course-meta">Module 2 of 6 · Classes &amp; Objects</div>
                            <div class="progress-wrap">
                                <div class="progress-bar"><div class="progress-fill" style="width:28%"></div></div>
                                <div class="progress-label">28% complete</div>
                            </div>
                        </div>
                    </div>

                    <div class="course-item">
                        <div class="course-icon">ALG</div>
                        <div class="course-info">
                            <div class="course-name">Algorithms &amp; Data Structures</div>
                            <div class="course-meta">Module 1 of 10 · Introduction</div>
                            <div class="progress-wrap">
                                <div class="progress-bar"><div class="progress-fill" style="width:8%"></div></div>
                                <div class="progress-label">8% complete</div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Recent Activity -->
            <div class="panel">
                <div class="panel-header">
                    <span class="panel-title">Recent Activity</span>
                </div>
                <div class="activity-list">
                    <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                            <div class="activity-text">Completed exercise: <strong>Loop Patterns</strong></div>
                            <div class="activity-time">2 hours ago</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                            <div class="activity-text">Scored 90% on quiz: <strong>Data Types</strong></div>
                            <div class="activity-time">Yesterday</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                            <div class="activity-text">Started course: <strong>Algorithms &amp; Data Structures</strong></div>
                            <div class="activity-time">2 days ago</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                            <div class="activity-text">Submitted code review for <strong>OOP Module 1</strong></div>
                            <div class="activity-time">3 days ago</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                            <div class="activity-text">Earned badge: <strong>7-Day Streak</strong></div>
                            <div class="activity-time">Today</div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>

</div>
</body>
</html>

