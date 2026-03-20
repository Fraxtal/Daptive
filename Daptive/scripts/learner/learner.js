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