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
    posts.forEach(function (post) {
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
    document.querySelectorAll('.row-item.active').forEach(function (e) {
        e.classList.remove('active');
    });
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

function formatAspDate(aspDate) {
    if (!aspDate) { return ''; }
    var timestamp = parseInt(aspDate.replace(/\D/g, ''));
    var d = new Date(timestamp);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
}