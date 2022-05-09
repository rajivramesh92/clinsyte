var mapDispatchToProps = dispatch => {
  return {
    getChartActivities: (userId, token, options, callback) => {
      getChartActivities(userId, token, options, (response, error) => {
        if(response) {
          if(response.data.status.toLowerCase() === 'success') {
            callback(response.data.data);
          }
          else {
            showToast(response.data.errors, 'error');
          }
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      });
    },

    getPatientCareteam: (patientId, token, callback) => {
      getCareteam(patientId, token, (response, error) => {
        if (response && response.data.status === 'success') {
          callback(response.data.data);
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      });
    }
  }
}

var mapStateToProps = state => {

  var { auth, careteamWithMembers } = state;
  var { user, token } = auth;
  var careteamMembers = isPatient(user) ? [careteamWithMembers.patient].concat(careteamWithMembers.members) : [];

  return { token, user, careteamMembers };
}

const PatientChartActivities = connect(mapStateToProps, mapDispatchToProps)(PatientChartActivitiesView);
