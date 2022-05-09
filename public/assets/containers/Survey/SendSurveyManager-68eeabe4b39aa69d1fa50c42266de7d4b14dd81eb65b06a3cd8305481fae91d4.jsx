var mapStateToProps = (state) => {
  return {
    careteams: state.careteams,
    surveys: state.surveys,
    token: state.auth.token
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    sendSurveyRequest: (token, id, patient_ids, callback) => {
      sendSurveyRequest(token, { id, patient_ids }, (response, error) => {
        if(response) {
          if(response.data.status.toLowerCase() === 'success') {
            showToast(response.data.data, 'success')
          }
          else {
            showToast(response.data.data.errors, 'error')
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error')
        }
      })
    }
  }
}

SendSurveyManager = connect(mapStateToProps,mapDispatchToProps)(SendSurvey);
