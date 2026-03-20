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
        body: JSON.stringify({ quizId: currentQuizId, usrCode: curCode })
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

        setTimeout(function () {
            rowItem.scrollIntoView({ behavior: 'smooth', block: 'start' });
            if (container.monacoEditor) {
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