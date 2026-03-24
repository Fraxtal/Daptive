require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.41.0/min/vs' } });

require(['vs/editor/editor.main'], function () {
    monaco.editor.setTheme('vs-dark');

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

function toggleMenuFold() {
    var sidebar = document.getElementById('menu-sidebar');
    var btn = document.getElementById('btn-menu');
    sidebar.classList.toggle('folded');
    if (sidebar.classList.contains('folded')) {
        btn.innerHTML = '&#10095;';
        localStorage.setItem('menuFolded', 'true');
    } else {
        btn.innerHTML = '&#10094;';
        localStorage.setItem('menuFolded', 'false');
    }

    setTimeout(function () {
        var containers = document.querySelectorAll('.section-container');
        containers.forEach(function (container) {
            if (container.monacoEditor) {
                container.monacoEditor.layout();
            }
        });
    }, 300);
}

document.addEventListener('DOMContentLoaded', function () {
    var isFolded = localStorage.getItem('menuFolded') === 'true';
    if (isFolded) {
        document.getElementById('menu-sidebar').classList.add('folded');
        document.getElementById('btn-menu').innerHTML = '&#10095;';
    }
});