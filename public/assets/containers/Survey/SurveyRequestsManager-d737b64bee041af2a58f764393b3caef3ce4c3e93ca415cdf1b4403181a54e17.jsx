var mapStateToProps = (state) => {
  return {
    token: state.auth.token,
    surveys: state.surveys,
    careteamMembers: state.careteamWithMembers.members
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    getSurveyRequests: (options, token, callback) => {
      getSurveyRequests(options, token, (response, error) => {
        if (response) {
          if (response.data.status.toLowerCase() === 'success') {
            if (options.page > 1) {
              dispatch(appendSurveys(response.data.data));
            }
            else {
              dispatch(setSurveys(response.data.data));
            }
            callback(response.data.data);
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    }
  }
}

const SurveyRequestsManager = connect(mapStateToProps, mapDispatchToProps)(SurveyRequests);
