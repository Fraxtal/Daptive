<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentResults.aspx.cs" Inherits="Daptive.views.lecturer.StudentResults" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive - Student Results</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Mono:wght@300;400;500&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="../../styles/dashboard.css" />
    <link rel="stylesheet" href="../../styles/lecturer/managequizzes.css" />
    <style>
      /* Scoped styles for the student results modal to make it larger and scrollable */
      #studentModal .modal-content {
        width: 94%;
        max-width: 1100px;
        max-height: 84vh; /* keep some space for viewport */
        box-sizing: border-box;
        overflow: hidden; /* keep header/footer visible */
      }

      /* Make the results area scrollable while keeping modal header/footer fixed */
      #studentModal #studentResultBody {
        max-height: calc(84vh - 120px); /* reserve space for title/footer */
        overflow-y: auto;
        padding-right: 12px; /* avoid content hiding behind scrollbar */
      }

      /* Ensure table inside modal expands to container width */
      #studentModal table {
        width: 100%;
        border-collapse: collapse;
      }

      /* Optional: improve readability inside modal */
      #studentModal .modal-title { display: block; margin-bottom: 8px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="sm" />
        <!-- server-side action buttons used for functional postbacks -->
        <asp:HiddenField runat="server" ID="hfStudentId" ClientIDMode="Static" />
        <asp:Button runat="server" ID="btnLoadStudentResults" Style="display:none;" OnClick="btnLoadStudentResults_Click" />
        <div class="shell">
            <!-- TOP BAR -->
            <header class="topbar">
                <div class="topbar-brand">
                    <div class="triangle-wrap">
                        <!-- logo svg omitted -->
                    </div>
                    <span class="brand">CodeDaptive</span>
                </div>
                <div class="topbar-right">
                    <div class="topbar-user"><div class="avatar">LC</div><span>Lecturer</span></div>
                    <asp:Button ID="btnSignout" runat="server" class="btn-signout" OnClick="btnsignout_click" Text="Logout"></asp:Button>
                </div>
            </header>

            <!-- ── SIDEBAR ── -->
            <aside class="sidebar">
              <span class="sidebar-section-label">Main</span>
              <a href="LecturerDashboard.aspx" class="nav-item">
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
                 <a href="StudentResults.aspx" class="nav-item active">
                  <span class="nav-icon">
                    <svg width="14" height="14" viewBox="0 0 12 12" xmlns="http://www.w3.org/2000/svg" class="nav-icon-svg" aria-hidden="true">
                      <polygon points="6,0 12,6 6,12 0,6" fill="none" stroke="currentColor" stroke-width="1.2" />
                    </svg>
                  </span> Student Progress
                </a>
              <a href="QuizResults.aspx" class="nav-item">
                <span class="nav-icon">
                  <svg width="14" height="14" viewBox="0 0 12 12" xmlns="http://www.w3.org/2000/svg" class="nav-icon-svg" aria-hidden="true">
                    <polygon points="6,0 12,6 6,12 0,6" fill="none" stroke="currentColor" stroke-width="1.2" />
                  </svg>
                </span> Quiz Results
              </a>
              <div class="sidebar-footer">© 2025 CodeDaptive</div>
            </aside>

            <!-- MAIN -->
            <main class="main">
                <div class="page-header"><p class="page-eyebrow">Lecturer Portal</p><h1 class="page-title">Students</h1></div>

                <div class="panel">
                    <div class="panel-header"><span class="panel-title">Learners</span></div>
                    <asp:GridView runat="server" ID="gvStudents" CssClass="table" AutoGenerateColumns="false" OnRowCommand="gvStudents_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="DisplayName" HeaderText="Name" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                            <asp:TemplateField HeaderText="Actions">
                                <ItemTemplate>
                                    <asp:Button runat="server" ID="btnViewResults" CssClass="btn-outline" Text="View Results" CommandName="ViewResults" CommandArgument='<%# Eval("UserID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <!-- Student results modal -->
                    <div id="studentModal" class="modal" style="display:none;">
                        <div class="modal-content">
                            <asp:Label runat="server" ID="lblStudentModalTitle" CssClass="modal-title">Student Results</asp:Label>
                            <div id="studentResultBody">
                                <asp:Literal runat="server" ID="litStudentResults"> <p class="section-hint">Loading...</p> </asp:Literal>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn-outline" onclick="closeStudentModal()">Close</button>
                            </div>
                        </div>
                    </div>

                </div>
            </main>
        </div>
    </form>

    <script>
      // Client script only handles UI interactions (opening modal and triggering server postback)
      function openStudentModalClient(el) {
        var id = el.getAttribute('data-id');
        // set hidden field (use ClientID to be robust)
        var hf = document.getElementById('<%= hfStudentId.ClientID %>');
        if (hf) hf.value = id;
        // invoke postback for the hidden button using UniqueID
        if (typeof __doPostBack === 'function') {
          __doPostBack('<%= btnLoadStudentResults.UniqueID %>', '');
          return;
        }
        // fallback: click the hidden button element
        var btn = document.getElementById('<%= btnLoadStudentResults.ClientID %>');
        if (btn) btn.click();
      }

      function closeStudentModal() { document.getElementById('studentModal').style.display = 'none'; }
    </script>
</body>
</html>
