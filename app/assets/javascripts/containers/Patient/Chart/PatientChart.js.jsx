var mapStateToProps = (state) => {
  return {
    token: state.auth.token,
    user: state.auth.user,
    careteams: state.careteams
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    searchChart: (query, entity, token, asyncCallback) => {
      searchChart(query, entity, token, (response) => {
        if(response)
          if(response.data.status === 'success') {
            asyncCallback(response.data.data);
          }
        else {
          //do nothing if any errors from backend
        }
      })
    },

    sendChart: (id, chart, beingApproved, token, callback) => {
      sendChartDetails(id, chart, beingApproved, token, (response, error) => {
        if (response) {
          if (response.data.status === 'success' ){
            showToast('Chart ' + (beingApproved ? 'approved' : 'updated') + ' successfully', 'success');
            callback(response.data.data)
          }
          else {
            showToast(response.data.errors, 'error')
          }
        }
        else{
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    },

    takeDosage: (planGroupId, planId, token) => {
      takeDosage(planGroupId, planId, token, (response,error) => {
        if (response) {
          if(response.data.status === 'success') {
            showToast(response.data.data, 'success');
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

    approveOrphanPlan: (planId, token, callback) => {
      changeOrphanPlanOwner(planId, token, (response, error) => {
        if (response) {
          if (response.data.status === 'success') {
            showToast('Orphan treatment plan successfully approved', 'success');
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

    removeOrphanPlan: (planId, token, callback) => {
      removeOrphanPlan(planId, token, (response, error) => {
        if (response) {
          if (response.data.status === 'success') {
            showToast('Orphan treatment plan successfully deleted', 'success');
            callback(true);
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

    removeTpdRequests: (patientId, token, callback) => {
      removeTpdRequests(patientId, token, (response, error) => {
        if (response && response.data.status === 'success') {
          showToast('All pending requests for treatment plan dependent surveys removed successfully', 'success');
          callback(true, dispatch);
        }
        else {
          showToast(SOMETHINGWRONG, 'error');
        }
      })
    }
  }
}

const PatientChart = connect(mapStateToProps, mapDispatchToProps)(PatientChartView);
