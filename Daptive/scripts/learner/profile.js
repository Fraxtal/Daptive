function showAuth() {
    document.getElementById('authModal').style.display = 'flex';
    document.getElementById('txtAuthPassword').value = '';
}

function hideAuth() {
    document.getElementById('authModal').style.display = 'none';
}

function validateAuth() {
    const password = document.getElementById('txtAuthPassword').value;
    //server-side validation
    fetch('LearnerView_Profile.aspx/VerifyPassword', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=utf-8'
        },
        body: JSON.stringify({ password })
    })
        .then(response => response.json())
        .then(data => {
            if (data.d === true) {
                hideAuth();
                enableEditing();
                document.getElementById('btnEditProfile').style.display = 'none';
                document.getElementById('btnSaveChanges').style.display = 'block';
                showSuccessText('Authentication successful! You can now edit your profile.');
            } else {
                showErrorText('Password does not match! Please try again.');
            }
        })
        .catch(error => {
            showErrorText('An error occurred during authentication. Please try again later.' + error);
        });
}

function enableEditing() {
    const editableFields = document.querySelectorAll('.editable-target');
    editableFields.forEach(field => field.removeAttribute('readonly'));
}