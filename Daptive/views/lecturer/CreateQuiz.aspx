<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateQuiz.aspx.cs" Inherits="Daptive.views.lecturer.CreateQuiz1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Create Quiz</title>
    <link
      href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Mono:wght@300;400;500&family=DM+Sans:wght@300;400;500&display=swap"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="../../styles/dashboard.css" />
    <link rel="stylesheet" href="../../styles/lecturer/createquiz.css" />
</head>
<body>
    <form id="form1" runat="server">
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
            <a href="CreateQuiz.aspx" class="nav-item active">
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
              <h1 class="page-title">Create Quiz</h1>
            </div>

            <div class="create-grid">
              <!-- LEFT: Quiz metadata + problem statement -->
              <div style="display: flex; flex-direction: column; gap: 20px">
                <!-- Quiz Info -->
                <div class="panel">
                  <div class="panel-header">
                    <span class="panel-title">Quiz Info</span>
                  </div>

                  <div class="form-group">
                    <label class="form-label">Quiz Name</label>
                    <asp:TextBox runat="server" ID="txtQuizName" ClientIDMode="Static" CssClass="form-input" placeholder="e.g. Reverse a String" />
                  </div>
                </div>

                <!-- Problem Statement -->
                <div class="panel">
                  <div class="panel-header">
                    <span class="panel-title">Problem Statement</span>
                    <span class="preview-pill">📄 Learner sees this</span>
                  </div>
                  <p class="section-hint">
                    Describe the problem clearly. Include constraints, examples, and
                    expected behaviour.
                  </p>
                  <div class="form-group">
                    <label class="form-label">Content</label>
                    <asp:TextBox runat="server" ID="txtQuizContent" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-textarea" Style="min-height:320px" placeholder='Given a string s, return the string reversed.&#10;&#10;Example:&#10;  Input:  "hello"&#10;  Output: "olleh"&#10;&#10;Constraints:&#10;  1 ≤ s.length ≤ 1000'></asp:TextBox>
                  </div>
                </div>
              </div>

              <div style="display: flex; flex-direction: column; gap: 20px">

                <!-- Test Cases -->
                <div class="panel">
                  <div class="testcases-header">
                    <span class="panel-title">Test Cases</span>
                    <button type="button" class="btn-outline" onclick="addTestCase()">
                      + Add Test Case
                    </button>
                  </div>
                  <p class="section-hint">
                    Each submission is run against these cases. Score = passed cases
                    ÷ total cases × 100.
                  </p>

                  <asp:HiddenField runat="server" ID="hfTestCases" ClientIDMode="Static" />
                  <div id="testcaseList"></div>

                  <div class="form-actions">
                    <button class="btn-outline" onclick="history.back()">
                      Cancel
                    </button>
                    <asp:Button runat="server" ID="btnPublishQuiz" CssClass="btn-primary" Text="Publish Quiz" OnClick="SaveQuiz_Click" OnClientClick="return prepareQuizSubmission();" />
                  </div>
                </div>
              </div>
            </div>
          </main>
        </div>

        <script>
          let tcCount = 0;

          function addTestCase() {
            try {
              tcCount++;
              const n = tcCount;
              const list = document.getElementById('testcaseList');
              if (!list) {
                console.error('testcaseList container not found');
                return;
              }

              const card = document.createElement('div');
              card.className = 'testcase-card';
              card.id = `tc-${n}`;

              // Input group
              const grp1 = document.createElement('div');
              grp1.className = 'form-group';
              const lbl1 = document.createElement('label');
              lbl1.className = 'form-label';
              lbl1.textContent = 'Input (TestCase)';
              const inp1 = document.createElement('input');
              inp1.type = 'text';
              inp1.className = 'form-input';
              inp1.placeholder = 'e.g. "hello"';
              grp1.appendChild(lbl1);
              grp1.appendChild(inp1);

              // Expected group
              const grp2 = document.createElement('div');
              grp2.className = 'form-group';
              const lbl2 = document.createElement('label');
              lbl2.className = 'form-label';
              lbl2.textContent = 'Expected Output';
              const inp2 = document.createElement('input');
              inp2.type = 'text';
              inp2.className = 'form-input';
              inp2.placeholder = 'e.g. "olleh"';
              grp2.appendChild(lbl2);
              grp2.appendChild(inp2);

              // Remove button
              const btn = document.createElement('button');
              btn.type = 'button';
              btn.className = 'btn-remove';
              btn.title = 'Remove';
              btn.textContent = '✕';
              btn.addEventListener('click', function (ev) { ev.stopPropagation(); removeTestCase(n); });

              card.appendChild(grp1);
              card.appendChild(grp2);
              card.appendChild(btn);

              list.appendChild(card);
              // optional: scroll to new card
              card.scrollIntoView({ behavior: 'smooth', block: 'center' });
            } catch (err) {
              console.error('addTestCase error', err);
            }
          }

          function removeTestCase(n) {
            if (document.querySelectorAll(".testcase-card").length <= 3) {
              alert("A minimum of 3 test cases is required.");
              return;
            }
            document.getElementById(`tc-${n}`)?.remove();
          }

          function prepareQuizSubmission() {
            const cards = document.querySelectorAll('.testcase-card');
            const parts = [];
            for (const card of cards) {
              const inputs = card.querySelectorAll('input');
              const tc = (inputs[0]?.value || '').trim();
              const er = (inputs[1]?.value || '').trim();
              // Escape delimiters
              const escTc = tc.replace(/\|\|/g, '');
              const escEr = er.replace(/\|\|/g, '');
              parts.push(escTc + '::' + escEr);
            }

            document.getElementById('hfTestCases').value = parts.join('||');
            // Let server perform validation and show alerts
            return true;
          }

          // Start with 3 test cases (minimum)
          addTestCase();
          addTestCase();
          addTestCase();
        </script>
    </form>
</body>
</html>
