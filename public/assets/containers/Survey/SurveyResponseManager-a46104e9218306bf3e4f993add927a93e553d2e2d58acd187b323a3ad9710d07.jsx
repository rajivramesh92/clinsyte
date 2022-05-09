var mapStateToProps = (state) => {
  return {
    token: state.auth.token
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    getSurveyRequest: (token, requestId, callback) => {
      getSurveyRequest(token, requestId, (response, error) => {
        if(response) {
          if(response.data.status.toLowerCase() === 'success') {
            callback(response.data.data)
          }
          else {
            showToast(response.data.errors, 'error')
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error')
        }
      })
    },
    startSurvey: (token, surveyId, requestId, callback) => {
      startSurvey(token, surveyId, { request_id: requestId} , (response, error) => {
        if(response) {
          if(response.data.status.toLowerCase() === 'success') {
            var startedAt = new Date().getTime();
            callback(startedAt)
            dispatch(startResponse(requestId, startedAt))
          }
          else {
            showToast(response.data.errors, 'error')
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error')
        }
      })
    },
    sendResponse: (token, surveyId, survey, callback) => {
      sendResponse(token, surveyId, survey, (response, error) => {
        if(response) {
          if(response.data.status.toLowerCase() === 'success') {
            callback(response.data.data)
            dispatch(updateSurveys(response.data.data))
          }
          else {
            showToast(response.data.errors, 'error')
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    }
  }
}

const SurveyResponseManager = connect(mapStateToProps, mapDispatchToProps)(SurveyResponse)
