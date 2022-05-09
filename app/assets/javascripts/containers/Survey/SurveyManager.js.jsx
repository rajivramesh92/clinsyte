var mapStateToProps = (state) => {
  return {
    token: state.auth.token,
    user: state.auth.user,
    surveys: state.surveys,
    patients: state.careteams ? _.map(state.careteams, 'patient') : [],
    lists: state.lists
  }
}

var mapDispatchToProps = (dispatch, ownProps) => {
  path = ownProps.route.path;
  var method = path === 'create' ? 'POST' : 'PUT';
  var action = path === 'create' ? 'created' : 'updated';
  return {
    sendSurvey: (token, params, surveyId, callback) => {
      sendSurvey(token, params, method, (response, error) => {
        if(response) {
          if(response.data.status.toLowerCase() === 'success') {
            showToast('Survey ' + action + ' successfully', 'success')
            dispatch(updateSurveys(response.data.data))
            if(callback) {
              callback(response.data.data);
            }
          }
          else {
            showToast(response.data.errors, 'error')
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      }, surveyId)
    },
    getSurveys: (page, token, callback) => {
      getSurveys(page, token, (response, error) => {
        if(response) {
          if(response.data.status.toLowerCase() === 'success') {
            dispatch(appendSurveys(response.data.data || []));
            callback(response.data.data);
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error')
        }
      })
    },
    getSurvey: (token, surveyId, callback) => {
      getSurvey(token, surveyId, (response, error) => {
        if(response) {
          if(response.data.status.toLowerCase() === 'success') {
            callback(response.data.data)
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    },
    deleteSurvey: (token, surveyId, callback) => {
      deleteSurvey(token, surveyId, (response, error) => {
        if(response) {
          if(response.data.status.toLowerCase() === 'success') {
            showToast(response.data.data, 'success')
            callback();
          }
          else {
            showToast(response.data.errors, 'error')
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    },
    getQuestionStats: (questionId, type, selectedPatient, token, callback) => {
      var params = {
        type,
        patient_id: selectedPatient
      }
      getGraphData(questionId, params, token, (response, error) => {
        if(response) {
          callback(response.data)
        }
        else {
          callback(error)
        }
      })
    },
    getSentRequests: (surveyId, page, token, callback) => {
      getSentRequests(surveyId, page, token, (response, error) => {
        if(response) {
          if(response.data.status === 'success') {
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

class SurveyManager extends Component {

  renderComponent() {
    if(this.props.route.path === 'create') {
      return <CreateSurvey {...this.props} />
    }
    else if(this.props.route.path === 'edit') {
      return <EditSurvey {...this.props} />
    }
    else if(this.props.params.id) {
      return <SurveyView {...this.props} />
    }
    else {
      return <SurveysList {...this.props} />
    }
  }

  render() {
    return this.renderComponent();
  }
}

SurveyManager = connect(mapStateToProps, mapDispatchToProps)(SurveyManager);
