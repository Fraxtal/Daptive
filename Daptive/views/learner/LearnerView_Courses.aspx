<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearnerView_Courses.aspx.cs" Inherits="Daptive.views.LearnerView_Courses" %>
<%@ Register Src="~/views/learner/logo.ascx" TagPrefix="custom" TagName="Logo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="~/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="../../styles/dashboard.css" />
    <link rel="stylesheet" href="~/styles/learner/course.css" runat="server"/>
    <title>CodeDaptive</title>
</head>
<body>
    <form id="form1" runat="server">
        <ul>
            <li><a href="LearnerView_Dashboard.aspx"><custom:Logo runat="server" ID="MainBrandLogo" /></a></li>
            <li><a href="LearnerView_Courses.aspx">Courses</a></li>
            <li><a href="LearnerView_Assessments.aspx">Assessments</a></li>
            <li><a href="LearnerView_Profile.aspx">Profile</a></li>
            <li><asp:Button ID="btnSignout" runat="server" class="btn-signout" OnClick="btnsignout_click" style="margin: auto 30px" Text="Logout"></asp:Button></li>
        </ul>
        <div id="err-container"></div>
        <div class="layout-container">
            <div class="sidebar">
                <h3>Topics</h3>
                <asp:Repeater ID="rptSidebar" runat="server" OnItemCommand="rptSidebar_ItemCommand">
                    <ItemTemplate>
                        <asp:LinkButton ID="lnkCourse" runat="server"
                            CommandName="LoadCourse"
                            CommandArgument='<%# Eval("Id") %>'
                            Text='<%# Eval("Name") %>'/>
                    </ItemTemplate> 
                </asp:Repeater>
            </div>
            <div class="main-content">
                <div id="Topic" runat="server">
                    <h2 id="contentTopic" runat="server">Welcome to CodeDaptive</h2>
                    <br />
                    <div class="course-text">
                        <asp:Literal id="contentTopicDesc" runat="server" Text="Nice to meet you! Get started by clicking any course on the left"></asp:Literal>
                    </div>
                </div>
                <asp:Repeater ID="rptContent" runat="server">
                    <ItemTemplate>
                        <h2><%#Eval("Name") %></h2>

                        <div class="course-text">
                            <asp:Literal ID="litContent" runat="server" Text='<%# Eval("Content") %>'></asp:Literal>
                        </div>

                        <h3>Try it yourself</h3>

                        <div class="section-container">
                            <div class="monaco-container"></div>

                            <textarea class="hidden-textbox" style="display:none;">
                                <%# HttpUtility.HtmlEncode(Eval("DefaultCode").ToString()) %>
                            </textarea>

                            <button type="button" class="btn-run" 
                                onclick="executeCodeAJAX(this)">
                                ▶ Execute
                            </button>
                            <h3>Terminal Output:</h3>
                            <div class="output-box">
                                <asp:Literal ID="litOutput" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div class="divider">Next Section</div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </form>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.41.0/min/vs/loader.min.js"></script>
    <script>
        require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.41.0/min/vs' } });

        require(['vs/editor/editor.main'], function () {
            var containers = document.querySelectorAll('.section-container')
            containers.forEach(function (container) {
                // get default code from hidden textbox
                var hiddenTextbox = container.querySelector('.hidden-textbox')
                var initialCode = hiddenTextbox.value.trim();

                // init for Monaco Editor in div
                var editor = monaco.editor.create(container.querySelector('.monaco-container'), {
                    value: initialCode,
                    language: 'csharp',    // language C#
                    theme: 'vs-dark',      //  VS Code dark theme
                    automaticLayout: true, // Auto fit
                    fontSize: 14,
                    minimap: { enabled: false }
                });
                container.monacoEditor = editor;
            })
        });

        //update the code before submit to runner
        function syncCodeBeforeSubmit(self) {
            var container = self.closest('.section-container')
            if (container && container.monacoEditor) {
                var hiddenTextbox = container.querySelector('.hidden-textbox');
                hiddenTextbox.value = container.monacoEditor.getValue();
            }
            // return true to continue the process
            return true; 
        }

        function executeCodeAJAX(self) {
            var container = self.closest('.section-container');
            if (!container || !container.monacoEditor) return;
            var curCode = container.monacoEditor.getValue();
            var outputLit = container.querySelector('.output-box')
            outputLit.innerHTML = "<span style='color: #0e639c;'>Executing...</span>";
            fetch('LearnerView_Courses.aspx/RunUsrCodeAJAX', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=utf-8'
                },
                body: JSON.stringify({ code: curCode })
            })
                .then(response => response.json())
                .then(data => {
                    var result = data.d;
                    if (result.IsPassed) {
                        outputLit.innerText = result.Message;
                    } else {
                        var errorMsg = result.Message.replace(/\n/g, '<br>');
                        outputLit.innerHTML = "<span style='color:#ff5555; font-weight:bold;'>" + errorMsg + "</span>";
                    }
                })
                .catch(error => {
                    showErrorText("Something went wrong. Please try again.");
                });
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
    </script>
</body>
</html>
