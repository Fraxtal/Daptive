<%@ Page Language="C#" AutoEventWireup="True" CodeBehind="Register.aspx.cs" Inherits="Daptive.Register" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Create Account</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Mono:wght@300;400;500&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="~/Daptive/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/authentication/register.css" runat="server"/>
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
                    <p class="tagline">Start your C#<br/>journey today.</p>
                    <p class="sub">Join thousands of learners and educators already using CodeDaptive to write, learn, and grow their programming skills.</p>
                </div>

                <div class="role-info-cards">
                    <div class="role-card student-card">
                        <span class="role-badge">Student</span>
                        <p>Access structured lessons, coding challenges, quizzes, and personal progress tracking.</p>
                    </div>
                    <div class="role-card lecturer-card">
                        <span class="role-badge">Lecturer</span>
                        <p>Create and publish courses, manage student enrolments, and review submissions.</p>
                    </div>
                </div>

                <p class="left-footer">© 2025 CodeDaptive. All rights reserved.</p>
            </div>
        </div>

        <!-- RIGHT PANEL -->
        <div class="right-panel">
            <div class="form-card register-card">
                <div class="form-header">
                    <p class="form-eyebrow">Get started</p>
                    <h2 class="form-title">Create your account</h2>
                </div>

                <form id="registerForm" runat="server">
                    <asp:Label ID="lblMessage" runat="server" CssClass="alert-msg" Visible="false"></asp:Label>
                    <asp:Label ID="lblSuccess" runat="server" CssClass="success-msg" Visible="false"></asp:Label>

                    <!-- Role Selector -->
                <div class="field-group">
                    <label>I am a</label>

                    <div class="role-toggle">

                        <label class="role-option">
                            <asp:RadioButton ID="rbStudent" runat="server" GroupName="Role" Checked="true" />
                            <span>Student</span>
                        </label>

                        <label class="role-option">
                            <asp:RadioButton ID="rbLecturer" runat="server" GroupName="Role" />
                            <span>Lecturer</span>
                     </label>

                    </div>
                </div>

                    <!-- Username -->
                    <div class="field-group">
                        <label>Username</label>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="input-field" placeholder="Choose a username" />
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                            ControlToValidate="txtUsername"
                            ErrorMessage="Username is required."
                            CssClass="val-error" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revUsername" runat="server"
                            ControlToValidate="txtUsername"
                            ValidationExpression="^[a-zA-Z0-9_]{3,20}$"
                            ErrorMessage="3–20 characters, letters, numbers or underscore only."
                            CssClass="val-error" Display="Dynamic" />
                    </div>

                    <!-- Full Name -->
                    <div class="field-group">
                        <label>Full Name</label>
                        <asp:TextBox ID="txtFullName" runat="server" CssClass="input-field" placeholder="Your full name" />
                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                            ControlToValidate="txtFullName"
                            ErrorMessage="Full name is required."
                            CssClass="val-error" Display="Dynamic" />
                    </div>

                    <!-- Email -->
                    <div class="field-group">
                        <label>Email Address</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="input-field" placeholder="you@example.com" />
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                            ControlToValidate="txtEmail"
                            ErrorMessage="Email is required."
                            CssClass="val-error" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server"
                            ControlToValidate="txtEmail"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                            ErrorMessage="Enter a valid email address."
                            CssClass="val-error" Display="Dynamic" />
                    </div>

                    <!-- Password -->
                    <div class="field-group">
                        <label>Password</label>
                        <div class="pw-wrap">
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="input-field" placeholder="Min. 8 characters" />
                            <button type="button" class="pw-toggle" onclick="togglePw(this)">Show</button>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                            ControlToValidate="txtPassword"
                            ErrorMessage="Password is required."
                            CssClass="val-error" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revPassword" runat="server"
                            ControlToValidate="txtPassword"
                            ValidationExpression="^.{8,}$"
                            ErrorMessage="Password must be at least 8 characters."
                            CssClass="val-error" Display="Dynamic" />
                    </div>

                    <!-- Confirm Password -->
                    <div class="field-group">
                        <label>Confirm Password</label>
                        <div class="pw-wrap">
                            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="input-field" placeholder="Re-enter your password" />
                            <button type="button" class="pw-toggle" onclick="togglePw(this)">Show</button>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvConfirm" runat="server"
                            ControlToValidate="txtConfirmPassword"
                            ErrorMessage="Please confirm your password."
                            CssClass="val-error" Display="Dynamic" />
                        <asp:CompareValidator ID="cvPassword" runat="server"
                            ControlToValidate="txtConfirmPassword"
                            ControlToCompare="txtPassword"
                            ErrorMessage="Passwords do not match."
                            CssClass="val-error" Display="Dynamic" />
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn-primary" OnClick="btnRegister_Click" />

                    <div class="divider"><span>or</span></div>

                    <p class="register-cta">Already have an account? <a href="Login.aspx">Sign in</a></p>
                </form>
            </div>
        </div>
    </div>

    <script>
        function togglePw(btn) {
            const input = btn.previousElementSibling;
            if (input.type === 'password') { input.type = 'text';     btn.textContent = 'Hide'; }
            else                           { input.type = 'password'; btn.textContent = 'Show'; }
        }
    </script>
</body>
</html>
