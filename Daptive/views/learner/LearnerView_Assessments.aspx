<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearnerView_Assessments.aspx.cs" Inherits="Daptive.views.LearnerView_Assessments" %>
<%@ Register Src="~/views/learner/logo.ascx" TagPrefix="custom" TagName="Logo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <link rel="stylesheet" href="~/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/dashboard.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/assessment.css" runat="server"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div class="top-bar">
                <div class="logo-container">
                    <custom:Logo runat="server" ID="MainBrandLogo" />
                </div>
                <asp:Button ID="btnSignout" runat="server" class="btn-signout" UseSubmitBehavior="false" OnClick="btnsignout_click" style="margin-left: auto" Text="Logout"></asp:Button>
            </div>
            <div id="err-container"></div>
             <div class="layout-container">
                 <div class="sidebar">
                     <ul>
                         <li><a href="LearnerView_Dashboard.aspx">Dashboard Overview</a></li>
                         <li><a href="LearnerView_Courses.aspx">Courses</a></li>
                         <li><a href="LearnerView_Assessments.aspx" class="active">Assessments</a></li>
                         <li><a href="LearnerView_Forum.aspx">Forum</a></li>
                         <li><a href="LearnerView_Profile.aspx">Profile</a></li>
                     </ul>
                 </div>
                <div class="main-content">
                    <h1>Quizzes</h1>
                    <br />
                    <asp:Repeater ID="rptAssessment" runat="server">
                        <ItemTemplate>
                            <div class="row-item">
                                <div class="row-header" onclick="toggleFocusMode(this)">
                                    <div class="flex-wrapper">
                                        <div class="content-left" style="flex: 1">
                                            <span><%# Eval("Question") %></span>
                                        </div>
                                        <div class="content-right" style="flex: 0 0 25%">
                                            <span id="score-<%# Eval("QuizId") %>">Highest Score: <%# Eval("Score", "{0:F0}") %>%</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="row-content">
                                    <div class="flex-wrapper">
                                        <div class="content-left">
                                            <asp:Literal ID="litContent" runat="server" Text='<%# Eval("Description") %>'></asp:Literal>
                                        </div>
                                        <div class="content-right">
                                            <h3>Your solution</h3>

                                            <div class="section-container" data-quizid="<%# Eval("QuizId") %>">
                                                <div class="monaco-container"></div>
                                                <textarea class="hidden-textbox"
                                                    style="display: none;">
    public class Program
    {
        public static void Main()
        {
            // Your code here
            //Output to console
            //Console.WriteLine();
        }
    }
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
                                        </div>
                                    </div>       
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.41.0/min/vs/loader.min.js"></script>
        <script>
            require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.41.0/min/vs' } });
            var isMonacoEngineReady = false;
            require(['vs/editor/editor.main'], function () {
                isMonacoEngineReady = true;
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
                var currentQuizId = parseInt(container.getAttribute('data-quizid'));
                var outputLit = container.querySelector('.output-box')
                outputLit.innerHTML = "<span style='color: #0e639c;'>Executing...</span>";
                fetch('LearnerView_Assessments.aspx/ReviewUsrCodeAJAX', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=utf-8'
                    },
                    body: JSON.stringify({ quizId:currentQuizId, usrCode: curCode })
                })
                    .then(response => response.json())
                    .then(data => {
                        var result = data.d;
                        if (result.Score >= 0) {
                            document.getElementById('score-' + currentQuizId).innerText = "Highest Score: " + (result.Score).toFixed(0) + "%";
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

            function toggleFocusMode(header) {
                var rowItem = header.closest('.row-item');
                var mainContent = document.querySelector('.main-content');

                if (rowItem.classList.contains('active')) {
                    rowItem.classList.remove('active');
                    mainContent.style.overflowY = 'auto';
                } else {
                    document.querySelectorAll('.row-item.active').forEach(function (e) {
                        e.classList.remove('active');
                    });
                    rowItem.classList.add('active');

                    var container = rowItem.querySelector('.section-container')
                    if (isMonacoEngineReady && container && !container.monacoEditor) {
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
                    }

                    setTimeout(function() {
                        rowItem.scrollIntoView({ behavior: 'smooth', block: 'start' });
                        if(container.monacoEditor) {
                        container.monacoEditor.layout();
                        }
                    }, 300)
                }
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
    </form>
</body>
</html>
