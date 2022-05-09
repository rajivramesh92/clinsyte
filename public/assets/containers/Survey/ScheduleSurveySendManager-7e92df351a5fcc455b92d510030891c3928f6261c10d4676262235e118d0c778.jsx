var surveySuccessSchedule = 'Survey scheduled successfully';

var mapStateToProps = (state) => {
  return {
    surveys: state.surveys,
    token: state.auth.token
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    configureScheduler: (data, token, type, callback) => {
      configureScheduler(data, token, type, (response, error) => {
        if(response) {
          if(response.data.status === 'success') {
            showToast(surveySuccessSchedule, 'success');
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

    getSchedules: (token, type, callback) => {
      getSchedules(token, type, (response, error) => {
        if(response && response.data.status === 'success') {
          callback(response.data.data);
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    },

    deleteSchedule: (scheduleId, token, type, callback) => {
      deleteSchedule(scheduleId, token, type, (response, error) => {
        if(response && response.data.status === 'success') {
          showToast('Schedule deleted successfully', 'error');
          callback();
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    },

    getChartItems: (item, token, callback) => {
      getChartItems(item, token, (response, error) => {
        if(response && response.data.status === 'success') {
          callback(response.data.data);
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    }
  }
}

const ScheduleSurveySendManager = connect(mapStateToProps, mapDispatchToProps)(ScheduleSurveySend);
