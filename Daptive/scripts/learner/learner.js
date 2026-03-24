
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