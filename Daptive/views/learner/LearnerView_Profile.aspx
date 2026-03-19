<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearnerView_Profile.aspx.cs" Inherits="Daptive.views.learner.LearnerView_Profile" %>
<%@ Register Src="~/views/learner/logo.ascx" TagPrefix="custom" TagName="Logo" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="~/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/dashboard.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/profile.css" runat="server"/>
    <title>CodeDaptive - My Profile</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="top-bar">
            <div class="logo-container">
                <custom:Logo runat="server" ID="MainBrandLogo" />
            </div>
        </div>
        <div id="err-container"></div>
        <div id="suc-container"></div>

        <div class="layout-container">
            <div class="sidebar">
                <ul>
                    <li><a href="LearnerView_Dashboard.aspx">Dashboard Overview</a></li>
                    <li><a href="LearnerView_Courses.aspx">Courses</a></li>
                    <li><a href="LearnerView_Assessments.aspx">Assessments</a></li>
                    <li><a href="LearnerView_Profile.aspx" class="active">Profile</a></li>
                </ul>
            </div>

            <div class="main-content">
                <div class="page-header">
                    <h2>My Profile</h2>
                    <p>Manage your personal information and account settings.</p>
                </div>

                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="alert-msg"></asp:Label>

                <div class="content-block profile-form-block">
                    <div class="block-header">
                        <h3>Account Details</h3>
                        <span class="block-badge">Editable</span>
                    </div>
                    
                    <div class="block-body">
                        <div class="form-grid">
                            <div class="form-group">
                                <label>User ID</label>
                                <asp:TextBox ID="txtUserId" runat="server" CssClass="form-control readonly-input" ReadOnly="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>Role</label>
                                <asp:TextBox ID="txtRole" runat="server" CssClass="form-control readonly-input" ReadOnly="true"></asp:TextBox>
                            </div>

                            <div class="form-group full-width">
                                <label>Username</label>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control editable-target" required="true"></asp:TextBox>
                            </div>
                            <div class="form-group full-width">
                                <label>Full Name</label>
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control editable-target"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control editable-target" TextMode="Email" required="true"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>Password</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control editable-target" TextMode="Password"></asp:TextBox>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" id="btnEditProfile" class="btn-action-primary" onclick="showAuth()">Edit Profile</button>
                            <asp:Button ID="btnSaveChanges" runat="server" Text="Save Changes" CssClass="btn-action-primary" style="display:none;" OnClick="btnSaveChanges_Click"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="authModal" class="modal-overlay" style="display: none">
            <div class="modal-content">
                <h3>Authentication Required</h3>
                <p>Please enter your current password to edit your profile.</p>

                <input type="password" id="txtAuthPassword" class="form-control" placeholder="Current Password" required="required" />
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="hideAuth()">Cancel</button>
                    <button type="button" class="btn-confirm" onclick="validateAuth()">Authenticate</button>
                </div>
            </div>
        </div>
    </form>
    <script>
        function showAuth() {
            document.getElementById('authModal').style.display = 'flex';
            document.getElementById('txtAuthPassword').value = '';
        }

        function hideAuth() {
            document.getElementById('authModal').style.display = 'none';
        }

        function validateAuth() {
            const password = document.getElementById('txtAuthPassword').value;
            //server-side validation
            fetch('LearnerView_Profile.aspx/VerifyPassword', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=utf-8'
                },
                body: JSON.stringify({ password })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.d === true) {
                        hideAuth();
                        enableEditing();
                        document.getElementById('btnEditProfile').style.display = 'none';
                        document.getElementById('<%= btnSaveChanges.ClientID %>').style.display = 'block';
                        document.getElementById('<%= txtUsername.ClientID %>').focus();
                        showSuccessText('Authentication successful! You can now edit your profile.');
                    } else {
                        showErrorText('Password does not match! Please try again.');
                    }
                })
                .catch(error => {
                    showErrorText('An error occurred during authentication. Please try again later.' + ex);
                });
        }

        function enableEditing() {
            const editableFields = document.querySelectorAll('.editable-target');
            editableFields.forEach(field => field.removeAttribute('readonly'));
        }

        function showErrorText(message) {
            var container = document.getElementById('err-container');

            var txt = document.createElement('div');
            txt.className = 'error-text';
            txt.innerHTML = message;

            container.prepend(txt);

            setTimeout(function () {
                txt.style.opacity = '0';
                txt.style.transform = 'translateY(-20px)';
                setTimeout(function () {
                    txt.remove();
                }, 400);
            }, 4000);
        }

        function showSuccessText(message) {
            var container = document.getElementById('suc-container');

            var txt = document.createElement('div');
            txt.className = 'success-text';
            txt.innerHTML = message;

            container.prepend(txt);

            setTimeout(function () {
                txt.style.opacity = '0';
                txt.style.transform = 'translateY(-20px)';
                setTimeout(function () {
                    txt.remove();
                }, 400);
            }, 4000);
        }
        </script>
</body>
</html>