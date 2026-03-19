<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuizResults.aspx.cs" Inherits="Daptive.views.lecturer.QuizResults" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive - Quiz Results</title>
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
              <a href="StudentResults.aspx" class="nav-item">
                <span class="nav-icon">
                  <svg width="14" height="14" viewBox="0 0 12 12" xmlns="http://www.w3.org/2000/svg" class="nav-icon-svg" aria-hidden="true">
                    <polygon points="6,0 12,6 6,12 0,6" fill="none" stroke="currentColor" stroke-width="1.2" />
                  </svg>
                </span> Student Progress
              </a>
              <a href="QuizResults.aspx" class="nav-item active">
              <span class="nav-icon">
                <svg width="14" height="14" viewBox="0 0 12 12" xmlns="http://www.w3.org/2000/svg" class="nav-icon-svg" aria-hidden="true">
                  <polygon points="6,0 12,6 6,12 0,6" fill="none" stroke="currentColor" stroke-width="1.2" />
                </svg>
              </span> Quiz Results
            </a>
              <div class="sidebar-footer">© 2025 CodeDaptive</div>
            </aside>

            <main class="main">
                <div class="page-header">
                    <p class="page-eyebrow">Lecturer Portal</p>
                    <h1 class="page-title">Quiz Results</h1>
                </div>

                <div class="panel">
                    <div class="panel-header"><span class="panel-title">Completed Quizzes</span></div>
                    <div class="panel-controls" style="display:flex; gap:8px; align-items:center; margin-bottom:12px;">
                        <input id="txtSearch" class="form-input" placeholder="Search quizzes or learners..." style="flex:1; max-width:420px;" />
                        <div style="display:flex; gap:8px; align-items:center;">
                          <button type="button" id="btnArrange" class="btn-primary" aria-label="Open arrange modal">Arrange</button>
                          <button type="button" id="btnResetArrange" class="btn-ghost">Reset</button>
                        </div>
                    </div>

                    <asp:GridView runat="server" ID="gvResults" CssClass="table" AutoGenerateColumns="false">
                        <Columns>
                            <asp:BoundField DataField="Quiz" HeaderText="Quiz" />
                            <asp:BoundField DataField="Description" HeaderText="Description" />
                            <asp:BoundField DataField="Learner" HeaderText="Learner" />
                        </Columns>
                    </asp:GridView>

                    <!-- Arrange modal -->
                    <div id="arrangeModal" class="modal" style="display:none;">
                      <div class="modal-content" style="max-width:420px; width:100%;">
                        <h3>Arrange Table</h3>
                        <div style="margin-top:8px;">
                          <label style="display:block; margin-bottom:6px; font-weight:600;">Visible columns</label>
                          <label><input type="checkbox" data-col="Quiz" checked /> Quiz</label><br />
                          <label><input type="checkbox" data-col="Description" checked /> Description</label><br />
                          <label><input type="checkbox" data-col="Learner" checked /> Learner</label>
                        </div>

                        <div style="margin-top:12px;">
                          <label style="display:block; margin-bottom:6px; font-weight:600;">Sort by</label>
                          <select id="selSortBy" style="width:100%; padding:6px;">
                            <option value="">(no sort)</option>
                            <option value="Quiz">Quiz</option>
                            <option value="Description">Description</option>
                            <option value="Learner">Learner</option>
                          </select>
                          <div style="display:flex; gap:8px; margin-top:8px;"><label><input type="radio" name="sortOrder" value="asc" checked /> Asc</label><label><input type="radio" name="sortOrder" value="desc" /> Desc</label></div>
                        </div>

                        <div style="display:flex; gap:8px; justify-content:flex-end; margin-top:12px;">
                          <button type="button" class="btn-outline" onclick="closeArrangeModal()">Cancel</button>
                          <button type="button" class="btn-primary" id="btnApplyArrange">Apply</button>
                        </div>
                      </div>
                    </div>
                </div>
            </main>
        </div>
    </form>
    <script>
      // client-side table search and arrange functionality
      (function(){
        function getGridRows() {
          const gv = document.getElementById('<%= gvResults.ClientID %>');
          return gv ? Array.from(gv.tBodies[0].rows) : [];
        }

        const txt = document.getElementById('txtSearch');
        if (txt) {
          txt.addEventListener('input', function(){
            const q = (this.value || '').toLowerCase();
            const rows = getGridRows();
            rows.forEach(r=>{
              const cells = Array.from(r.cells).map(c=> (c.textContent||'').toLowerCase());
              r.style.display = q === '' || cells.some(t=> t.indexOf(q) !== -1) ? '' : 'none';
            });
          });
        }

        document.getElementById('btnArrange').addEventListener('click', function(){ document.getElementById('arrangeModal').style.display = 'flex'; });
        document.getElementById('btnResetArrange').addEventListener('click', function(){
          const gv = document.getElementById('<%= gvResults.ClientID %>');
          if (!gv) return;
          // show all headers and cells
          const thead = gv.tHead ? Array.from(gv.tHead.rows[0].cells) : [];
          const tbodyRows = Array.from(gv.tBodies[0].rows);
          thead.forEach(h => h.style.display = '');
          tbodyRows.forEach(r => Array.from(r.cells).forEach(c => c.style.display = ''));
          // clear search
          const txt = document.getElementById('txtSearch'); if (txt) txt.value = '';
          // reset arrange modal controls to default
          document.querySelectorAll('#arrangeModal input[type=checkbox][data-col]').forEach(c => c.checked = true);
          document.getElementById('selSortBy').value = '';
          document.querySelector('#arrangeModal input[name=sortOrder][value="asc"]').checked = true;
        });
        document.getElementById('btnApplyArrange').addEventListener('click', function(){
          // apply visibility
          const checks = Array.from(document.querySelectorAll('#arrangeModal input[type=checkbox][data-col]'));
          const gv = document.getElementById('<%= gvResults.ClientID %>');
          if (!gv) return closeArrangeModal();
          const headerCells = gv.tHead ? Array.from(gv.tHead.rows[0].cells) : [];
          const colMap = { 'Quiz':0, 'Description':1, 'Learner':2 };
          checks.forEach(ch=>{
            const col = ch.getAttribute('data-col');
            const idx = colMap[col];
            if (typeof idx === 'number') {
              // toggle header
              if (headerCells[idx]) headerCells[idx].style.display = ch.checked ? '' : 'none';
              // toggle rows
              const rows = getGridRows();
              rows.forEach(r=> { if (r.cells[idx]) r.cells[idx].style.display = ch.checked ? '' : 'none'; });
            }
          });

          // apply sort
          const sortBy = document.getElementById('selSortBy').value;
          const order = (document.querySelector('#arrangeModal input[name=sortOrder]:checked')||{}).value || 'asc';
          if (sortBy) {
            const idx = { 'Quiz':0, 'Description':1, 'Learner':2 }[sortBy];
            const tbody = gv.tBodies[0];
            const rows = Array.from(tbody.rows);
            rows.sort(function(a,b){
              const av = (a.cells[idx] && a.cells[idx].textContent||'').trim().toLowerCase();
              const bv = (b.cells[idx] && b.cells[idx].textContent||'').trim().toLowerCase();
              return (av < bv ? -1 : av > bv ? 1 : 0) * (order === 'asc' ? 1 : -1);
            });
            rows.forEach(r=> tbody.appendChild(r));
          }

          closeArrangeModal();
        });

        window.closeArrangeModal = function(){ document.getElementById('arrangeModal').style.display = 'none'; }
      })();
    </script>
</body>
</html>
