var mapStateToProps = (state) => {
  return {
    user: state.auth.user,
    token: state.auth.token
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    updateProfile: (data, userId, token) => {
      updateProfile(data, userId, token, (response, error) => {
        if (response) {
          if(response.data.status == 'success'){
            dispatch(setUser(response.data.data));
            showToast("Profile updated successfully", 'success');
          }
          else{
            showToast(response.data.errors, 'error')
          }
        }
        else {
          showToast('Something went wrong', 'error');
        }
      })
    }
  }
}

ProfileEdit = connect(mapStateToProps, mapDispatchToProps)(ProfileEditForm);
