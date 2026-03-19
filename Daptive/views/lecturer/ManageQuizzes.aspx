<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageQuizzes.aspx.cs" Inherits="Daptive.views.lecturer.ManageQuizzes" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive - Manage Quizzes</title>
    <link
      href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Mono:wght@300;400;500&family=DM+Sans:wght@300;400;500&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="../../styles/dashboard.css" />
    <link rel="stylesheet" href="../../styles/lecturer/managequizzes.css" />
</head>
    <body>
        <form id="form1" runat="server">
        <asp:ScriptManager runat="server" ID="sm" EnablePageMethods="true" />
        <asp:HiddenField runat="server" ID="hfModalQuizId" ClientIDMode="Static" />
        <asp:HiddenField runat="server" ID="hfModalQuizName" ClientIDMode="Static" />
        <asp:HiddenField runat="server" ID="hfModalQuizDesc" ClientIDMode="Static" />
        <asp:HiddenField runat="server" ID="hfModalQuizContent" ClientIDMode="Static" />
        <asp:HiddenField runat="server" ID="hfModalTestCases" ClientIDMode="Static" />
        <asp:HiddenField runat="server" ID="hfDeleteQuizId" ClientIDMode="Static" />
        <asp:Button runat="server" ID="btnModalSavePost" Style="display:none;" OnClick="btnModalSavePost_Click" />
        <asp:Button runat="server" ID="btnConfirmDeletePost" Style="display:none;" OnClick="btnConfirmDeletePost_Click" />
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
            <a href="ManageQuizzes.aspx" class="nav-item active">
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
            <a href="QuizResults.aspx" class="nav-item">
              <span class="nav-icon">
                <svg width="14" height="14" viewBox="0 0 12 12" xmlns="http://www.w3.org/2000/svg" class="nav-icon-svg" aria-hidden="true">
                  <polygon points="6,0 12,6 6,12 0,6" fill="none" stroke="currentColor" stroke-width="1.2" />
                </svg>
              </span> Quiz Results
            </a>
            <div class="sidebar-footer">© 2025 CodeDaptive</div>
          </aside>

          <!-- ── MAIN ── -->
          <main class="main">
            <div class="page-header">
              <p class="page-eyebrow">Lecturer Portal</p>
              <h1 class="page-title">Manage Quizzes</h1>
            </div>

            <div class="panel">
              <div class="panel-header">
                <span class="panel-title">Quizzes</span>
                <asp:Button runat="server" ID="btnCreateQuiz" CssClass="btn-outline" Text="+ Create Quiz" OnClientClick="window.location='CreateQuiz.aspx'; return false;" />
              </div>
              <p class="section-hint">View, edit or remove quizzes you have published.</p>

              <asp:GridView runat="server" ID="gvQuizzes" CssClass="table" AutoGenerateColumns="false" DataKeyNames="QuizId" OnRowCommand="gvQuizzes_RowCommand">
                <Columns>
                  <asp:BoundField DataField="QuizId" HeaderText="#" />
                  <asp:BoundField DataField="Quiz" HeaderText="Quiz" />
                  <asp:BoundField DataField="Description" HeaderText="Description" />
                  <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                      <button type="button" class="btn-outline" onclick="openEditMenu(this)" data-id='<%# Eval("QuizId") %>'>Edit</button>
                      <button type="button" class="btn-remove" onclick="openDeleteModal(this)" data-id='<%# Eval("QuizId") %>'>Delete</button>
                    </ItemTemplate>
                  </asp:TemplateField>
                </Columns>
              </asp:GridView>
            </div>

            <!-- Edit modal -->
            <div id="editModal" class="modal" style="display:none;">
              <div class="modal-content">
                <h3>Edit Quiz</h3>
                <p id="editModalTitle" class="section-hint"></p>

                <div class="modal-tabs" style="display:flex; gap:8px; margin-bottom:12px;">
                  <button type="button" class="btn-outline modal-tab active" id="btnEditInfo">Info</button>
                  <button type="button" class="btn-outline modal-tab" id="btnEditContent">Problem</button>
                  <button type="button" class="btn-outline modal-tab" id="btnEditTests">Tests</button>
                </div>

                <div id="editBody">
                  <!-- Info -->
                  <div id="editSectionInfo" style="display:none;">
                    <div class="form-group">
                      <label class="form-label">Quiz Name</label>
                      <input id="modalQuizName" class="form-input" />
                    </div>
                    <div class="form-group">
                      <label class="form-label">Description</label>
                      <textarea id="modalQuizDesc" class="form-textarea" style="min-height:100px"></textarea>
                    </div>
                  </div>

                  <!-- Content -->
                  <div id="editSectionContent" style="display:none;">
                    <div class="form-group">
                      <label class="form-label">Problem Statement</label>
                      <textarea id="modalQuizContent" class="form-textarea" style="min-height:180px"></textarea>
                    </div>
                  </div>

                  <!-- Tests -->
                  <div id="editSectionTests" style="display:none;">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">
                      <div class="section-hint">Manage test cases for this quiz.</div>
                      <button type="button" class="btn-outline" id="btnModalAddTest">+ Add Test Case</button>
                    </div>
                    <div id="modalTestList"></div>
                  </div>
                </div>

                <div style="display:flex; gap:8px; justify-content:flex-end; margin-top:12px;">
                      <button type="button" class="btn-outline" onclick="closeModal('editModal')">Cancel</button>
                  <button type="button" class="btn-primary" id="btnModalSave" onclick="submitModalChanges()">Save Changes</button>
                </div>
              </div>
            </div>

            <!-- Delete confirmation modal -->
            <div id="deleteModal" class="modal" style="display:none;">
              <div class="modal-content">
                <h3>Delete Quiz</h3>
                <p class="section-hint">Are you sure you want to delete this quiz? This action cannot be undone.</p>
                <div style="display:flex; gap:10px; justify-content:flex-end; margin-top:12px;">
                  <button type="button" class="btn-outline" onclick="closeModal('deleteModal')">Cancel</button>
                  <button type="button" class="btn-remove" id="btnConfirmDelete">Delete</button>
                </div>
              </div>
            </div>

            <script>
              let currentQuizId = null;

              function openEditMenu(el) {
                currentQuizId = el.getAttribute('data-id');
                const titleEl = document.getElementById('editModalTitle');
                titleEl.textContent = 'Quiz #' + currentQuizId;

                // initialize modal sections
                showEditSection('info');
                loadQuizIntoModal(currentQuizId);

                // wire section buttons
                document.getElementById('btnEditInfo').addEventListener('click', function(e){ e.preventDefault(); showEditSection('info'); setActiveTab('btnEditInfo'); });
                document.getElementById('btnEditContent').addEventListener('click', function(e){ e.preventDefault(); showEditSection('content'); setActiveTab('btnEditContent'); });
                document.getElementById('btnEditTests').addEventListener('click', function(e){ e.preventDefault(); showEditSection('tests'); setActiveTab('btnEditTests'); });

                document.getElementById('btnModalAddTest').addEventListener('click', function(e){ e.preventDefault(); addModalTestCase(); });
                document.getElementById('btnModalSave').addEventListener('click', function(e){ e.preventDefault(); saveModalChanges(); });

                document.getElementById('editModal').style.display = 'flex';
              }

              function setActiveTab(id) {
                document.querySelectorAll('.modal-tab').forEach(t=>t.classList.remove('active'));
                const el = document.getElementById(id); if (el) el.classList.add('active');
              }

              function submitModalChanges() {
                // move modal form data into hidden fields and postback to server
                document.getElementById('hfModalQuizId').value = currentQuizId || '';
                document.getElementById('hfModalQuizName').value = document.getElementById('modalQuizName').value.trim();
                document.getElementById('hfModalQuizDesc').value = document.getElementById('modalQuizDesc').value.trim();
                document.getElementById('hfModalQuizContent').value = document.getElementById('modalQuizContent').value.trim();
                // serialize testcases to simple JSON
                const cards = document.querySelectorAll('#modalTestList .testcase-card');
                const arr = [];
                cards.forEach(c=>{ const inputs = c.querySelectorAll('input'); if (inputs.length>=2) arr.push({ Input: inputs[0].value.trim(), Expected: inputs[1].value.trim() }); });
                document.getElementById('hfModalTestCases').value = JSON.stringify(arr);
                // trigger server postback
                document.getElementById('btnModalSavePost').click();
              }

              function showEditSection(name) {
                document.getElementById('editSectionInfo').style.display = name === 'info' ? 'block' : 'none';
                document.getElementById('editSectionContent').style.display = name === 'content' ? 'block' : 'none';
                document.getElementById('editSectionTests').style.display = name === 'tests' ? 'block' : 'none';
              }

              function loadQuizIntoModal(quizId) {
                // fetch quiz data from server
                fetch('ManageQuizzes.aspx/GetQuiz', {
                  method: 'POST', headers: { 'Content-Type':'application/json; charset=utf-8' }, body: JSON.stringify({ quizId: parseInt(quizId,10) })
                }).then(r=>r.json()).then(function(res){
                  const d = res && res.d ? res.d : res;
                  if (!d) return;
                  document.getElementById('modalQuizName').value = d.Quiz || '';
                  // populate both fields so user can edit description in either tab
                  document.getElementById('modalQuizDesc').value = d.Description || '';
                  document.getElementById('modalQuizContent').value = d.Description || '';
                  // focus first input for accessibility
                  document.getElementById('modalQuizName').focus();
                  // render testcases
                  renderModalTests(d.TestCases || []);
                }).catch(function(err){ console.error('GetQuiz failed', err); });
              }

              function renderModalTests(tests) {
                const list = document.getElementById('modalTestList');
                list.innerHTML = '';
                tests.forEach((t, i)=>{
                  const row = document.createElement('div');
                  row.className = 'testcase-card';
                  row.dataset.idx = i;
                  row.innerHTML = `<div class="form-group"><label class="form-label">Input</label><input class="form-input" value="${escapeHtml(t.TestCase || '')}" /></div>` +
                      `<div class="form-group"><label class="form-label">Expected</label><input class="form-input" value="${escapeHtml(t.ExpectedResult || '')}" /></div>` +
                      '</br>' +
                                  `<button type="button" class="btn-remove" aria-label="Delete test case">Delete</button>`;
                  row.querySelector('.btn-remove').addEventListener('click', ()=> row.remove());
                  list.appendChild(row);
                });
              }

              function addModalTestCase() {
                const list = document.getElementById('modalTestList');
                const card = document.createElement('div');
                card.className = 'testcase-card';
                card.innerHTML = `<div class="form-group"><label class="form-label">Input</label><input class="form-input" /></div>` +
                    `<div class="form-group"><label class="form-label">Expected</label><input class="form-input" /></div>` +
                                 '</br>' +
                                 `<button type="button" class="btn-remove" aria-label="Delete test case">Delete</button>`;
                card.querySelector('.btn-remove').addEventListener('click', ()=> card.remove());
                list.appendChild(card);
              }

              function saveModalChanges() {
                // prefer the problem statement field for description, fall back to short desc in info tab
                const descVal = (document.getElementById('modalQuizContent').value || '').trim() || (document.getElementById('modalQuizDesc').value || '').trim();
                const payload = { quizId: parseInt(currentQuizId,10), quiz: document.getElementById('modalQuizName').value.trim(), description: descVal, testcases: [] };
                const cards = document.querySelectorAll('#modalTestList .testcase-card');
                cards.forEach(c=>{
                  const inputs = c.querySelectorAll('input');
                  if (inputs.length >= 2) payload.testcases.push({ Input: inputs[0].value.trim(), Expected: inputs[1].value.trim() });
                });

                fetch('ManageQuizzes.aspx/SaveQuizChanges', {
                  method: 'POST', headers: { 'Content-Type':'application/json; charset=utf-8' }, body: JSON.stringify(payload)
                }).then(r=>r.json()).then(function(res){
                  const d = res && res.d ? res.d : res;
                  if (d && d.success) {
                    // update row in-place without full reload
                    try {
                      const selector = `button[data-id='${currentQuizId}']`;
                      const btn = document.querySelector(selector);
                      const tr = btn && btn.closest('tr');
                      if (tr) {
                        // columns: 0=QuizId,1=Quiz,2=Description
                        if (tr.cells.length >= 3) {
                          tr.cells[1].textContent = payload.quiz;
                          tr.cells[2].textContent = payload.description;
                        } else {
                          // fallback: try to update any text nodes
                          const quizCell = tr.querySelector('.quiz-name'); if (quizCell) quizCell.textContent = payload.quiz;
                          const descCell = tr.querySelector('.quiz-desc'); if (descCell) descCell.textContent = payload.description;
                        }
                      }
                    } catch (err) {
                      console.warn('Failed to update row in-place', err);
                    }
                    closeModal('editModal');
                  } else {
                    alert('Failed to save changes');
                  }
                }).catch(e=>{ console.error(e); alert('Failed to save changes'); });
              }

              function escapeHtml(s) { return (s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;'); }

              function openDeleteModal(el) {
                currentQuizId = el.getAttribute('data-id');
                document.getElementById('deleteModal').style.display = 'flex';
                // set hidden field for server-side deletion
                document.getElementById('hfDeleteQuizId').value = currentQuizId || '';
                document.getElementById('btnConfirmDelete').addEventListener('click', function(e){ e.preventDefault(); document.getElementById('btnConfirmDeletePost').click(); });
              }

              function closeModal(id) {
                document.getElementById(id).style.display = 'none';
              }

              function confirmDelete() {
                if (!currentQuizId) return;
                // Call page method to delete
                fetch('ManageQuizzes.aspx/DeleteQuiz', {
                  method: 'POST',
                  headers: { 'Content-Type': 'application/json; charset=utf-8' },
                  body: JSON.stringify({ quizId: parseInt(currentQuizId, 10) })
                }).then(r => r.json()).then(function(res) {
                  // ASP.NET returns { d: <value> }
                  const payload = res && res.d ? res.d : res;
                  if (payload && payload.success) {
                    // remove row from table
                    try {
                      const selector = `button[data-id='${currentQuizId}']`;
                      const btn = document.querySelector(selector);
                      const tr = btn && btn.closest('tr');
                      if (tr) tr.remove();
                    } catch (err) { console.warn('Failed to remove row', err); }
                    closeModal('deleteModal');
                  } else {
                    alert('Failed to delete quiz');
                    closeModal('deleteModal');
                  }
                }).catch(function(err){
                  console.error(err);
                  alert('Failed to delete quiz');
                  closeModal('deleteModal');
                });
              }
            </script>
          </main>
        </div>
    </form>
</body>
</html>