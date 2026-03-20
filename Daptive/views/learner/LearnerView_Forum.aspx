<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LearnerView_Forum.aspx.cs" Inherits="Daptive.views.learner.LearnerView_Forum" %>
<%@ Register Src="~/views/learner/logo.ascx" TagPrefix="custom" TagName="Logo" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="~/styles/authentication/login.css" runat="server"/>
    <link rel="stylesheet" href="~/styles/learner/forum.css" runat="server"/>
    <title>CodeDaptive</title>
</head>
<body>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.41.0/min/vs/loader.min.js"></script>
    <script>
        function toggleFocusMode(header, ForumId) {
            var rowItem = header.closest('.row-item');
            var repliesContainer = document.getElementById('replies-' + ForumId);
            if (rowItem.classList.contains('active')) {
                rowItem.classList.remove('active');
                repliesContainer.innerHTML = '';
            } else {
                document.querySelectorAll('.row-item.active').forEach(function (e) {
                    e.classList.remove('active');
                });
                rowItem.classList.add('active');
                repliesContainer.innerHTML = '<div style="padding: 10px; color: #666;">Loading replies...</div>';
                fetch('LearnerView_Forum.aspx/GetRepliesAJAX', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=utf-8;'
                    },
                    body: JSON.stringify({ ForumId: ForumId })
                })
                    .then(response => response.json())
                    .then(data => {
                        var replies = data.d;
                        var html = '';
                        if (replies.length === 0) {
                            html = '<div style="padding: 10px; color: #888;">No replies yet. Be the first to reply!</div>';
                        } else {
                            var html = replies.map(reply => `
                                <div class="reply-item" style="border-bottom: 1px solid #eee; padding: 15px 0;">
                                    <div style="margin-bottom: 8px; font-family: sans-serif;">
                                        <span style="color: var(--accent); font-weight: 600;">${reply.Author}</span>
                                        <span style="color: #888888; font-size: 0.85em; margin-left: 10px;">${formatAspDate(reply.PostedAt)}</span>
                                    </div>
                                    <div style="color: #333; line-height: 1.6;">${reply.Content}</div>
                                </div>
                            `).join('');
                        }
                        repliesContainer.innerHTML = html;
                    }).catch(error => {
                        repliesContainer.innerHTML = '<div style="padding: 10px; color: #888;">No replies yet. Be the first to reply!</div>';
                        showErrorText('Failed to load replies! Please try again.')
                    });
            }
        }

        function sendPost() {
            titleBox = document.getElementById('txtPostTitle');
            contentBox = document.getElementById('txtPostContent');
            fetch('LearnerView_Forum.aspx/SendPostAJAX', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=utf-8 '
                },
                body: JSON.stringify({ title: titleBox.value, content: contentBox.value })
            })
                .then(response => response.json())
                .then(data => {
                    var resultCode = data.d;
                    if (resultCode == 0) {
                        showSuccessText('Posted! Refreshing page.');
                        setTimeout(function () {
                            window.location.replace(window.location.href);
                        }, 1500);
                    } else {
                        showErrorText(resultCode == 1 ? 'Please fill in all the fields!' : 'Something went wrong! Please try agian.');
                    }
                })
                .catch(error => {
                    showErrorText('Something went wrong! Please try agian.' + error.message)
                })
        }

        function sendReply(self) {
            container = self.closest('.comment-area');
            txtArea = container.querySelector('.comment');
            ForumId = parseInt(container.getAttribute('data-id'));
            fetch('LearnerView_Forum.aspx/SendReplyAJAX', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=utf-8 '
                },
                body: JSON.stringify({ ForumId: ForumId, message: txtArea.value })
            })
                .then(response => response.json())
                .then(data => {
                    var resultCode = data.d;
                    if (resultCode == 0) {
                        showSuccessText('Posted! Refreshing page.');
                        setTimeout(function () {
                            window.location.replace(window.location.href);
                        }, 1500);
                    } else {
                        showErrorText(resultCode == 1 ? 'Sending empty message is not allowed!' : 'Something went wrong! Please try agian.');
                    }
                })
                .catch(error => {
                    showErrorText('Something went wrong! Please try agian.' + error.message)
                })
        }

        function showPost() {
            document.getElementById('post-box').style.display = 'flex';
        }

        function hidePost() {
            document.getElementById('post-box').style.display = 'none';
        }

        function search() {
            var keyword = document.querySelector('.search-bar').value.toLowerCase().trim();
            var posts = document.querySelectorAll('.row-item');
            posts.forEach(function(post) {
                var titleContainer = post.querySelector('.content-top');
                if (titleContainer) {
                    title = titleContainer.innerText.toLowerCase().trim();
                    if (title.includes(keyword)) {
                        post.style.display = '';
                    } else { post.style.display = 'none' }
                }
            });
        }

        function dateReverse(self) {
            self.classList.toggle('active');
            var icon = self.querySelector('.toggle-icon')
            if (self.classList.contains('active')) {
                icon.style.transform = 'rotate(180deg)';
            } else {
                icon.style.transform = 'rotate(0deg)';
            }
            var posts = Array.from(document.querySelectorAll('.row-item'));
            if (posts.length == 0) return;
            var container = posts[0].parentNode;
            posts.forEach(function (row) {
                row.initRect = row.getBoundingClientRect();
            });
            posts.reverse();
            posts.forEach(function (row) {
                container.appendChild(row);
            });
            requestAnimationFrame(function () {
                posts.forEach(function (row) {
                    row.endRect = row.getBoundingClientRect();
                    var dy = row.initRect.top - row.endRect.top;
                    row.style.transition = 'none';
                    row.style.transform = `translateY(${dy}px)`
                });
                requestAnimationFrame(function () {
                    posts.forEach(function (row) {
                        row.style.transition = 'all 0.4s ease-out';
                        row.style.transform = 'translateY(0)';
                    });
                });
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

        function formatAspDate(aspDate) {
            if (!aspDate) { return ''; }
            var timestamp = parseInt(aspDate.replace(/\D/g, ''));
            var d = new Date(timestamp);
            return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
        }
    </script>
    <form id="form1" runat="server">
        <div class="top-bar">
            <div class="logo-container">
                <custom:Logo runat="server" ID="MainBrandLogo" />
            </div>
            <asp:Button ID="btnSignout" runat="server" class="btn-signout" UseSubmitBehavior="false" OnClick="btnsignout_click" style="margin-left: auto" Text="Logout"></asp:Button>
        </div>
        <div id="err-container"></div>
        <div id="suc-container"></div>
        <div class="layout-container">
            <div class="sidebar" id="menu-sidebar">
                <ul>
                    <li><a href="LearnerView_Dashboard.aspx">Dashboard Overview</a></li>
                    <li><a href="LearnerView_Courses.aspx">Courses</a></li>
                    <li><a href="LearnerView_Assessments.aspx">Assessments</a></li>
                    <li><a href="LearnerView_Forum.aspx" class="active">Forum</a></li>
                    <li><a href="LearnerView_Profile.aspx">Profile</a></li>
                </ul>
            </div>
            <div class="main-content">
                <div class="header">
                    <h1>Learner Forum</h1>
                    <button class="btn-new" type="button" onclick="showPost()">Create Post</button>
                </div>
                <br />
                <div class="sub-header" style="">
                    <textarea class="search-bar" rows="1" 
                        oninput="this.style.height = ''; 
                        this.style.height = this.scrollHeight + 'px';
                        search()"
                        placeholder="Search"></textarea>
                    <button class="btn-date" type="button" onclick="dateReverse(this)">Date <span class="toggle-icon" style="display: inline-block; font-weight: bold; transition: transform 0.5s ease;">&#9660;</span></button>
                </div>
                <br />
                <asp:Repeater ID="rptForum" runat="server">
                    <ItemTemplate>
                        <div class="row-item">
                            <div class="row-header" onclick="toggleFocusMode(this, <%# Eval("ForumId") %>)">
                                <div class="flex-wrapper">
                                    <div class="content-top" style="flex: 1">
                                        <span><%# Eval("Title") %></span>
                                    </div>
                                    <div class="content-bot" style="flex: 0 0 25%">
                                        <span><%# Eval("Author") %> <%# Eval("PostedAt", "{0:MMM dd, yyyy}") %></span>
                                    </div>
                                </div>
                            </div>
                            <div class="row-content">
                                <div class="flex-wrapper">
                                    <div style="border-bottom: 1px solid rgba(45, 74, 62, 0.65); padding: 15px;">
                                        <asp:Literal ID="litContent" runat="server" Text='<%# Eval("Content") %>'></asp:Literal>
                                    </div>
                                    <div class="comment-area" data-id="<%# Eval("ForumId") %>">
                                        <textarea class="comment" rows="1" oninput="this.style.height = ''; this.style.height = this.scrollHeight + 'px'"></textarea>
                                        <button class="btn-new" type="button" onclick="sendReply(this)">Send</button>
                                    </div>
                                    <div class="replies-container" id='replies-<%# Eval("ForumId") %>'></div>
                                </div>       
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        <div class="post-box" id="post-box" style="display: none;">
            <div class="post-content">
                <h3>Post a new discussion</h3>
                <asp:TextBox ID="txtPostTitle" runat="server" CssClass="form-control" placeholder="Title" style="padding: 8px; border: 1px solid #ccc; border-radius: 4px;" />
                <asp:TextBox ID="txtPostContent" runat="server" TextMode="MultiLine" CssClass="form-control" placeholder="Content" style="margin-top: 10px; height: 100px; padding: 8px; border: 1px solid #ccc; border-radius: 4px; resize: vertical;" />
                <div class="post-actions">
                    <button class="btn-confirm" type="button" onclick="sendPost()">Send</button>
                    <button class="btn-cancel" type="button" onclick="hidePost()">Cancel</button>
                </div>  
            </div>
        </div>
    </form>
</body>
</html>
