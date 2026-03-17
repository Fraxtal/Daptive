<%@ Page Language="C#" AutoEventWireup="True" CodeBehind="Login.aspx.cs" Inherits="Daptive.Login" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Login</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Mono:wght@300;400;500&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="CSS/login.css" />
</head>
<body>
    <div class="page-wrapper">
        <!-- LEFT PANEL -->
        <div class="left-panel">
            <div class="left-inner">
                <div class="logo-block">
                    <div class="triangle-wrap">
                        <svg viewBox="0 0 120 110" width="340" height="320" xmlns="http://www.w3.org/2000/svg" class="triangle-svg">
                            <g stroke="#D4AF37" stroke-width="1.5" fill="none">
                                <polygon points="60,6 114,104 6,104"/>
                                <polygon points="60,14 108,100 12,100"/>
                                <polygon points="60,22 102,96 18,96"/>
                                <polygon points="60,30 96,92 24,92"/>
                                <polygon points="60,38 90,88 30,88"/>
                                <polygon points="60,46 84,84 36,84"/>
                                <polygon points="60,54 78,80 42,80"/>
                                <polygon points="60,62 72,76 48,76"/>
                                <!-- inner lines -->
                                <line x1="60" y1="6" x2="36" y2="84"/>
                                <line x1="60" y1="6" x2="48" y2="80"/>
                                <line x1="60" y1="6" x2="60" y2="76"/>
                                <line x1="60" y1="6" x2="72" y2="80"/>
                                <line x1="60" y1="6" x2="84" y2="84"/>
                                <line x1="6" y1="104" x2="84" y2="84"/>
                                <line x1="6" y1="104" x2="72" y2="80"/>
                                <line x1="6" y1="104" x2="60" y2="76"/>
                                <line x1="114" y1="104" x2="48" y2="80"/>
                                <line x1="114" y1="104" x2="36" y2="84"/>
                            </g>
                        </svg>
                    </div>
                    <h1 class="brand">CodeDaptive</h1>
                </div>

                <div class="tagline-block">
                    <p class="tagline">Master C# from zero<br/>to professional.</p>
                    <p class="sub">An adaptive learning platform built for students and lecturers. Write real code, receive instant feedback, and progress at your own pace.</p>
                </div>

                <div class="feature-list">
                    <div class="feat"><span class="feat-icon">◈</span><span>Structured C# curriculum with live exercises</span></div>
                    <div class="feat"><span class="feat-icon">◈</span><span>Lecturer tools to create and manage courses</span></div>
                    <div class="feat"><span class="feat-icon">◈</span><span>Track your progress across every topic</span></div>
                    <div class="feat"><span class="feat-icon">◈</span><span>Community forum and code review sessions</span></div>
                </div>

                <p class="left-footer">© 2025 CodeDaptive. All rights reserved.</p>
            </div>
        </div>

        <!-- RIGHT PANEL -->
        <div class="right-panel">
            <div class="form-card">
                <div class="form-header">
                    <p class="form-eyebrow">Welcome back</p>
                    <h2 class="form-title">Sign in to your account</h2>
                </div>

                <form id="loginForm" runat="server">
                    <asp:Label ID="lblMessage" runat="server" CssClass="alert-msg" Visible="false"></asp:Label>

                    <div class="field-group">
                        <label for="txtUsername">Username</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="input-field" placeholder="Enter your username" />
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                            ControlToValidate="txtUsername"
                            ErrorMessage="Username is required."
                            CssClass="val-error"
                            Display="Dynamic" />
                    </div>

                    <div class="field-group">
                        <label for="txtPassword">Password</label>
                        <div class="pw-wrap">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="input-field" placeholder="Enter your password" />
                            <button type="button" class="pw-toggle" onclick="togglePw(this)">Show</button>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                            ControlToValidate="txtPassword"
                            ErrorMessage="Password is required."
                            CssClass="val-error"
                            Display="Dynamic" />
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-primary" OnClick="btnLogin_Click" />

                    <div class="divider"><span>or</span></div>

                    <p class="register-cta">Don't have an account? <a href="Register.aspx">Create one free</a></p>
                </form>
            </div>
        </div>
    </div>

    <script>
        function togglePw(btn) {
            const input = btn.previousElementSibling;
            if (input.type === 'password') {
                input.type = 'text';
                btn.textContent = 'Hide';
            } else {
                input.type = 'password';
                btn.textContent = 'Show';
            }
        }
    </script>
</body>
</html>
