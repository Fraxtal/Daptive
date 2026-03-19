<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateCourse.aspx.cs" Inherits="Daptive.views.lecturer.CreateCourse" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>CodeDaptive – Create Course</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Serif+Display&family=DM+Mono:wght@300;400;500&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="../../styles/dashboard.css" />
    <link rel="stylesheet" href="../../styles/lecturer/createcourse.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="shell">

        <!-- ── TOP BAR ── -->
        <header class="topbar">
            <div class="topbar-brand">
                <div class="triangle-wrap">
                    <svg viewBox="0 0 120 110" xmlns="http://www.w3.org/2000/svg" class="triangle-svg">
                        <g stroke="#D4AF37" stroke-width="1.5" fill="none">
                            <polygon points="60,6 114,104 6,104"/>
                            <polygon points="60,22 102,96 18,96"/>
                            <polygon points="60,38 90,88 30,88"/>
                            <polygon points="60,54 78,80 42,80"/>
                            <line x1="60" y1="6" x2="60" y2="76"/>
                            <line x1="60" y1="6" x2="36" y2="84"/>
                            <line x1="60" y1="6" x2="84" y2="84"/>
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
            <a href="CreateCourse.aspx" class="nav-item active">
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
                <h1 class="page-title">Create Course</h1>
            </div>

            <!-- Step indicator -->
            <div class="step-indicator">
                <div class="step-item">
                    <div class="step-bubble active" id="bubble-1">1</div>
                    <span class="step-label active" id="label-1">Define Topic</span>
                </div>
                <div class="step-connector"></div>
                <div class="step-item">
                    <div class="step-bubble" id="bubble-2">2</div>
                    <span class="step-label" id="label-2">Build Lessons</span>
                </div>
            </div>

            <div class="wizard-wrap">

                <!-- LEFT: Course outline (persistent) -->
                <div class="outline-panel">
                    <span class="outline-label">Course Outline</span>
                    <div class="outline-topic-name" id="outlineTopicName">
                        <span class="outline-topic-empty">No topic yet…</span>
                    </div>
                    <hr class="outline-divider" />
                    <span class="outline-label">Lessons</span>
                    <div class="outline-list" id="outlineList">
                        <span class="outline-empty">No lessons added yet</span>
                    </div>
                </div>

                <!-- RIGHT: Steps -->
                <div>

                    <!-- ── STEP 1: Define Topic ── -->
                    <div class="step visible" id="step-1">
                        <div class="panel">
                            <div class="panel-header">
                                <span class="panel-title">Define Your Topic</span>
                            </div>
                            <p class="section-hint">A topic is the overarching subject. All lessons (courses) you build in the next step will live under this topic.</p>

                            <div class="form-group">
                                <label class="form-label">Use existing topic</label>
                                <div style="display:flex; gap:8px; align-items:center;">
                                    <label style="display:flex; align-items:center; gap:8px; font-size:0.9rem; color:var(--text-mid);">
                                        <input type="checkbox" id="chkUseExistingTopic" onchange="toggleExistingTopic(this.checked)" />
                                        <span style="font-size:0.9rem;">Enable</span>
                                    </label>
                                    <asp:DropDownList runat="server" ID="ddlExistingTopics" ClientIDMode="Static" CssClass="form-input" Style="display:none;"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Topic Name</label>
                                <asp:TextBox runat="server" ID="txtTopicName" ClientIDMode="Static" CssClass="form-input" placeholder="e.g. Loops in C#" oninput="updateOutlineTopic()" />
                            </div>
                            <div class="form-group" style="margin-bottom:0;">
                                <label class="form-label">Description</label>
                                <asp:TextBox runat="server" ID="txtTopicDesc" ClientIDMode="Static" TextMode="MultiLine" CssClass="form-textarea" Style="min-height:120px;" placeholder="A brief overview of what learners will explore in this topic…"></asp:TextBox>
                            </div>

            <div class="form-actions" style="margin-top:20px;">
                                <button type="button" class="btn-ghost" onclick="window.location='LecturerDashboard.aspx'">Cancel</button>
                                <button type="button" class="btn-primary" onclick="goToStep2()">Next — Build Lessons →</button>
                            </div>
                        </div>
                    </div>

                    <!-- ── STEP 2: Build Lessons ── -->
                    <div class="step" id="step-2">
                        <div class="panel" style="margin-bottom:20px;">
                            <div class="panel-header">
                                <span class="panel-title">Build Lessons</span>
                                <span class="preview-pill">📚 Sequential for learners</span>
                            </div>
                            <p class="section-hint">Each lesson is a course entry under your topic. Learners go through them in order. Expand a lesson to fill in its content and starter code.</p>
                        </div>

                        <asp:HiddenField runat="server" ID="hfLessons" ClientIDMode="Static" />
                        <div class="course-builder" id="courseBuilder"></div>

                        <button type="button" class="add-course-btn" onclick="addLesson()">+ Add Lesson</button>

                        <div class="form-actions" style="margin-top:20px;">
                            <button type="button" class="btn-ghost" onclick="goToStep1()">← Back</button>
                            <asp:Button runat="server" ID="btnPublishCourse" CssClass="btn-primary" Text="Publish Course" OnClick="PublishCourse_Click" OnClientClick="return prepareCourseSubmission();" />
                        </div>
                    </div>

                </div>
            </div>
        </main>
    </div>

    <script>
        let lessonCount = 0;

        /* ── Outline sync ── */
        function updateOutlineTopic() {
            const val = document.getElementById('txtTopicName').value.trim();
            document.getElementById('outlineTopicName').innerHTML =
                val ? `<strong>${val}</strong>` : '<span class="outline-topic-empty">No topic yet…</span>';
        }

        function updateOutlineList() {
            const list = document.getElementById('outlineList');
            const cards = document.querySelectorAll('.course-card');
            if (!cards.length) {
                list.innerHTML = '<span class="outline-empty">No lessons added yet</span>';
                return;
            }
            list.innerHTML = '';
            cards.forEach((card, i) => {
                const nameInput = card.querySelector('.lesson-name-input');
                const name = nameInput?.value.trim() || '';
                const item = document.createElement('div');
                item.className = 'outline-item';
                item.innerHTML = `<span class="outline-num">${i + 1}.</span><span class="outline-name">${name || '<em style="color:var(--text-light)">Untitled</em>'}</span>`;
                item.onclick = () => openCard(card);
                list.appendChild(item);
            });
        }

        /* ── Step navigation ── */
        function goToStep2() {
            const name = document.getElementById('txtTopicName').value.trim();
            if (!name) { alert('Please enter a topic name.'); return; }

            document.getElementById('step-1').classList.remove('visible');
            document.getElementById('step-2').classList.add('visible');

            document.getElementById('bubble-1').classList.replace('active', 'done');
            document.getElementById('bubble-1').textContent = '✓';
            document.getElementById('label-1').classList.remove('active');
            document.getElementById('bubble-2').classList.add('active');
            document.getElementById('label-2').classList.add('active');

            if (!lessonCount) addLesson(); // start with one lesson
        }

        function goToStep1() {
            document.getElementById('step-2').classList.remove('visible');
            document.getElementById('step-1').classList.add('visible');

            document.getElementById('bubble-1').classList.replace('done', 'active');
            document.getElementById('bubble-1').textContent = '1';
            document.getElementById('label-1').classList.add('active');
            document.getElementById('bubble-2').classList.remove('active');
            document.getElementById('label-2').classList.remove('active');
        }

        /* ── Lesson cards ── */
        function addLesson() {
            lessonCount++;
            const n = lessonCount;
            const builder = document.getElementById('courseBuilder');

            const card = document.createElement('div');
            card.className = 'course-card active-card';
            card.id = `lesson-${n}`;
            card.innerHTML = `
                <div class="course-card-header" onclick="toggleCard(${n})">
                    <span class="course-seq">${builder.children.length + 1}</span>
                    <span class="course-card-title placeholder" id="card-title-${n}">Untitled Lesson</span>
                    <button class="btn-remove-card" onclick="removeLesson(event, ${n})" title="Remove">✕</button>
                    <span class="card-chevron open" id="chevron-${n}">▼</span>
                </div>
                <div class="course-card-body open" id="body-${n}">
                    <div class="course-body-grid">
                        <div>
                            <div class="form-group">
                                <label class="form-label">Lesson Name</label>
                                <input type="text" class="form-input lesson-name-input"
                                    placeholder="e.g. The for Loop"
                                    oninput="syncCardTitle(${n}, this.value); updateOutlineList();" />
                            </div>
                            <div class="form-group" style="margin-bottom:0;">
                                <label class="form-label">Content <span class="preview-pill" style="margin-left:6px;">📄 Learner reads this</span></label>
                                <textarea class="form-textarea" style="min-height:220px;"
                                    placeholder="Explain the concept here. Include examples, syntax, and tips…"></textarea>
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label class="form-label">Starter Code <span class="preview-pill" style="margin-left:6px;">⌨ Free-run sandbox</span></label>
                            <textarea class="code-editor lesson-code" spellcheck="false">using System;

    class Program
    {
        static void Main(string[] args)
        {
            // Experiment freely!
        
        }
    }</textarea>
                        </div>
                    </div>
                </div>
            `;
            builder.appendChild(card);
            resequence();
            updateOutlineList();
        }

        function removeLesson(e, n) {
            e.stopPropagation();
            if (document.querySelectorAll('.course-card').length <= 1) {
                alert('A course must have at least one lesson.');
                return;
            }
            document.getElementById(`lesson-${n}`)?.remove();
            resequence();
            updateOutlineList();
        }

        function toggleCard(n) {
            const body = document.getElementById(`body-${n}`);
            const chevron = document.getElementById(`chevron-${n}`);
            const card = document.getElementById(`lesson-${n}`);
            const isOpen = body.classList.toggle('open');
            chevron.classList.toggle('open', isOpen);
            card.classList.toggle('active-card', isOpen);
        }

        function openCard(card) {
            const body = card.querySelector('.course-card-body');
            const chevron = card.querySelector('.card-chevron');
            body.classList.add('open');
            chevron.classList.add('open');
            card.classList.add('active-card');
            card.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }

        function syncCardTitle(n, val) {
            const el = document.getElementById(`card-title-${n}`);
            if (val.trim()) {
                el.textContent = val;
                el.classList.remove('placeholder');
            } else {
                el.textContent = 'Untitled Lesson';
                el.classList.add('placeholder');
            }
        }

        function resequence() {
            document.querySelectorAll('.course-card').forEach((card, i) => {
                card.querySelector('.course-seq').textContent = i + 1;
            });
        }

        /* ── Publish ── */
        function publishCourse() {
            const topicName = document.getElementById('txtTopicName').value.trim();
            const topicDesc = document.getElementById('txtTopicDesc').value.trim();
            const cards = document.querySelectorAll('.course-card');

            if (!cards.length) { alert('Please add at least one lesson.'); return; }

            const lessons = [];
            for (const card of cards) {
                const name = card.querySelector('.lesson-name-input').value.trim();
                const content = card.querySelector('.form-textarea').value.trim();
                const code = card.querySelector('.lesson-code').value.trim();
                if (!name) { alert('Please fill in all lesson names.'); openCard(card); return; }
                if (!content) { alert('Please fill in all lesson content.'); openCard(card); return; }
                lessons.push({ name, content, defaultCode: code });
            }

            const payload = {
                topic: { name: topicName, description: topicDesc },  // → topic table
                courses: lessons                                       // → course table (TopicId FK)
            };

            console.log('Payload:', payload);
            // TODO: POST to API
            alert(`Course published!\nTopic: "${topicName}"\n${lessons.length} lesson(s) created.`);
        }

        function prepareCourseSubmission() {
            // Serialize lessons into hidden field and let server-side validation/alerts handle user feedback
            const cards = document.querySelectorAll('.course-card');
            const parts = [];
            for (const card of cards) {
                const name = (card.querySelector('.lesson-name-input')?.value || '').trim();
                const content = (card.querySelector('.form-textarea')?.value || '').trim();
                const code = (card.querySelector('.lesson-code')?.value || '').trim();
                const escName = name.replace(/\|\|/g, '');
                const escContent = content.replace(/\|\|/g, '');
                const escCode = code.replace(/\|\|/g, '');
                parts.push(escName + '::' + escContent + '::' + escCode);
            }

            document.getElementById('hfLessons').value = parts.join('||');
            return true;
        }

        function toggleExistingTopic(enabled) {
            const ddl = document.getElementById('ddlExistingTopics');
            const txt = document.getElementById('txtTopicName');
            const desc = document.getElementById('txtTopicDesc');
            if (enabled) {
                // show dropdown and mark text fields readonly so their values still post
                ddl.style.display = 'block';
                txt.readOnly = true;
                desc.readOnly = true;
                // set textbox value from selected option so validation and postback work
                const selText = ddl.options[ddl.selectedIndex]?.text || '';
                txt.value = selText;
                desc.value = '';
                document.getElementById('outlineTopicName').innerHTML = selText ? `<strong>${selText}</strong>` : '<span class="outline-topic-empty">No topic yet…</span>';
                // update outline and textbox when selection changes
                ddl.onchange = () => {
                    const sel = ddl.options[ddl.selectedIndex]?.text || '';
                    txt.value = sel;
                    document.getElementById('outlineTopicName').innerHTML = sel ? `<strong>${sel}</strong>` : '<span class="outline-topic-empty">No topic yet…</span>';
                };
            } else {
                ddl.style.display = 'none';
                txt.readOnly = false;
                desc.readOnly = false;
                // restore outline from textbox
                txt.oninput = updateOutlineTopic;
                updateOutlineTopic();
            }
        }
    </script>
    </form>
</body>
</html>
