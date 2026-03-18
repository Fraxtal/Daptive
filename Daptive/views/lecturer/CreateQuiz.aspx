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
    <link rel="stylesheet" href="../../styles/createquiz.css" />
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
              <button class="btn-signout">Sign out</button>
            </div>
          </header>

          <!-- ── SIDEBAR ── -->
          <aside class="sidebar">
            <span class="sidebar-section-label">Main</span>
            <a href="LecturerDashboard.html" class="nav-item">
              <span class="nav-icon">◈</span> Dashboard
            </a>
            <a href="CreateQuiz.html" class="nav-item active">
              <span class="nav-icon">◈</span> Create Quiz
            </a>
            <a href="CreateCourse.html" class="nav-item">
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
                    <input
                      type="text"
                      class="form-input"
                      id="quizName"
                      placeholder="e.g. Reverse a String"
                    />
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
                    <textarea
                      class="form-textarea"
                      id="quizContent"
                      style="min-height: 320px"
                      placeholder='Given a string s, return the string reversed.&#10;&#10;Example:&#10;  Input:  "hello"&#10;  Output: "olleh"&#10;&#10;Constraints:&#10;  1 ≤ s.length ≤ 1000'
                    ></textarea>
                  </div>
                </div>
              </div>

              <!-- RIGHT: Default code + test cases -->
              <div style="display: flex; flex-direction: column; gap: 20px">
                <!-- Default Code -->
                <div class="panel">
                  <div class="panel-header">
                    <span class="panel-title">Starter Code</span>
                    <span class="preview-pill">⌨ Pre-filled in editor</span>
                  </div>
                  <p class="section-hint">
                    This code stub is shown to the learner when they open the quiz.
                    Leave method bodies empty for them to complete.
                  </p>
                  <div class="form-group">
                    <label class="form-label">DefaultCode (C#)</label>
                    <textarea
                      class="code-editor"
                      id="defaultCode"
                      spellcheck="false"
                    >
    public class Solution
    {
        public string Solve(string input)
        {
            // Write your solution here
        
        }
    }</textarea
                    >
                  </div>
                </div>

                <!-- Test Cases -->
                <div class="panel">
                  <div class="testcases-header">
                    <span class="panel-title">Test Cases</span>
                    <button class="btn-outline" onclick="addTestCase()">
                      + Add Test Case
                    </button>
                  </div>
                  <p class="section-hint">
                    Each submission is run against these cases. Score = passed cases
                    ÷ total cases × 100.
                  </p>

                  <div id="testcaseList"></div>

                  <div class="form-actions">
                    <button class="btn-outline" onclick="history.back()">
                      Cancel
                    </button>
                    <button class="btn-primary" onclick="saveQuiz()">
                      Publish Quiz
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </main>
        </div>

        <script>
          let tcCount = 0;

          function addTestCase() {
            tcCount++;
            const n = tcCount;
            const list = document.getElementById("testcaseList");

            const card = document.createElement("div");
            card.className = "testcase-card";
            card.id = `tc-${n}`;
            card.innerHTML = `
                <div class="form-group">
                    <label class="form-label">Input (TestCase)</label>
                    <input type="text" class="form-input" placeholder='e.g. "hello"' />
                </div>
                <div class="form-group">
                    <label class="form-label">Expected Output</label>
                    <input type="text" class="form-input" placeholder='e.g. "olleh"' />
                </div>
                <button class="btn-remove" onclick="removeTestCase(${n})" title="Remove">✕</button>
            `;
            list.appendChild(card);
          }

          function removeTestCase(n) {
            if (document.querySelectorAll(".testcase-card").length <= 3) {
              alert("A minimum of 3 test cases is required.");
              return;
            }
            document.getElementById(`tc-${n}`)?.remove();
          }

          function saveQuiz() {
            const name = document.getElementById("quizName").value.trim();
            const content = document.getElementById("quizContent").value.trim();
            const defaultCode = document.getElementById("defaultCode").value.trim();

            if (!name) {
              alert("Please enter a quiz name.");
              return;
            }
            if (!content) {
              alert("Please enter a problem statement.");
              return;
            }
            if (!defaultCode) {
              alert("Please provide starter code.");
              return;
            }

            const cards = document.querySelectorAll(".testcase-card");
            if (cards.length < 3) {
              alert("Please add at least 3 test cases.");
              return;
            }

            const testCases = [];
            for (const card of cards) {
              const inputs = card.querySelectorAll("input");
              const tc = inputs[0].value.trim();
              const er = inputs[1].value.trim();
              if (!tc || !er) {
                alert("Please fill in all test case fields.");
                return;
              }
              testCases.push({ testCase: tc, expectedResult: er });
            }

            const payload = {
              quiz: name,
              content,
              defaultCode,
              testCases, // → insert into testcase table (QuizId FK)
            };

            console.log("Quiz payload:", payload);
            // TODO: POST payload to API → quiz + testcase tables
            alert(
              `Quiz "${name}" published with ${testCases.length} test case(s)!`,
            );
          }

          // Start with 3 test cases (minimum)
          addTestCase();
          addTestCase();
          addTestCase();
        </script>
    </form>
</body>
</html>
