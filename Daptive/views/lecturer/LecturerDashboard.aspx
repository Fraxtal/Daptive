<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LecturerDashboard.aspx.cs" Inherits="Daptive.views.lecturer.WebForm1" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Lecturer Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Mono:wght@300;400;500&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="../../styles/dashboard.css" />
</head>
<body>
<div class="shell">

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
                <div class="avatar">LC</div>
                <span>Lecturer</span>
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
            <span class="nav-icon">◈</span> Create Quiz
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">◈</span> Create Course
        </a>
        <a href="#" class="nav-item">
            <span class="nav-icon">◈</span> Manage Quizzes
        </a>

        <span class="sidebar-section-label">Analytics</span>

        <a href="#" class="nav-item">
            <span class="nav-icon">◈</span> Student Progress
        </a>
        <a href="#" class="nav-item">
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
                <span class="stat-value">42</span>
                <span class="stat-sub">Active learners</span>
            </div>
            <div class="stat-card">
                <span class="stat-label">Quizzes Created</span>
                <span class="stat-value">15</span>
                <span class="stat-sub">C# exercises</span>
            </div>
            <div class="stat-card">
                <span class="stat-label">Avg Completion</span>
                <span class="stat-value">68%</span>
                <span class="stat-sub">Quiz attempts</span>
            </div>
            <div class="stat-card">
                <span class="stat-label">Avg Score</span>
                <span class="stat-value">75%</span>
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
                            <div class="course-meta">Add coding challenges for students</div>
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
                    <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                            <div class="activity-text"><strong>Alice</strong> scored 95% on Variables Quiz</div>
                            <div class="activity-time">10 minutes ago</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                            <div class="activity-text"><strong>Bob</strong> completed Loops Challenge</div>
                            <div class="activity-time">1 hour ago</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                            <div class="activity-text"><strong>Charlie</strong> attempted Arrays Quiz</div>
                            <div class="activity-time">2 hours ago</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                            <div class="activity-text"><strong>Diana</strong> scored 88% on OOP Basics</div>
                            <div class="activity-time">3 hours ago</div>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-dot"></div>
                        <div>
                            <div class="activity-text"><strong>Eve</strong> completed String Methods</div>
                            <div class="activity-time">5 hours ago</div>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Student Progress Overview -->
        <div class="panel" style="margin-top: 20px;">
            <div class="panel-header">
                <span class="panel-title">Top Performing Students</span>
                <a href="#" class="panel-action">View all</a>
            </div>
            <div class="course-list">

                <div class="course-item">
                    <div class="course-icon">A</div>
                    <div class="course-info">
                        <div class="course-name">Alice Johnson</div>
                        <div class="course-meta">12 quizzes completed</div>
                        <div class="progress-wrap">
                            <div class="progress-bar"><div class="progress-fill" style="width:92%"></div></div>
                            <div class="progress-label">92% average score</div>
                        </div>
                    </div>
                </div>

                <div class="course-item">
                    <div class="course-icon">D</div>
                    <div class="course-info">
                        <div class="course-name">Diana Smith</div>
                        <div class="course-meta">10 quizzes completed</div>
                        <div class="progress-wrap">
                            <div class="progress-bar"><div class="progress-fill" style="width:88%"></div></div>
                            <div class="progress-label">88% average score</div>
                        </div>
                    </div>
                </div>

                <div class="course-item">
                    <div class="course-icon">B</div>
                    <div class="course-info">
                        <div class="course-name">Bob Williams</div>
                        <div class="course-meta">11 quizzes completed</div>
                        <div class="progress-wrap">
                            <div class="progress-bar"><div class="progress-fill" style="width:85%"></div></div>
                            <div class="progress-label">85% average score</div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </main>

</div>
</body>
</html>
