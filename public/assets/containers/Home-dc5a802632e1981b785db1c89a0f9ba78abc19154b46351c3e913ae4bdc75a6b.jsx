var mapDispatchToProps = (dispatch) => {
  return {
    getSummary: (token, callback) => {
      getSummary(token, (response, error) => {
        if (response && response.data.status === 'success') {
          callback(response.data.data.summary);
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    }
  }
}

var mapStateToProps = (state) => {
  return {
    token: state.auth.token,
    user: state.auth.user,
    careteams: state.careteams
  };
}

Home = connect(mapStateToProps, mapDispatchToProps)(UserHome);
