const getChartDetails = (userId, authHeaders, callback) => {
  request({
    url: '/api/v1/users/' + userId + '/chart',
    headersToBeSent: authHeaders,
    method: 'GET',
  })
  .then(response => {
    if (response.data.status === 'success' && response.data.data !== null) {
      callback(response, undefined)
    }
    else if (response.data.data === null) {
      callback(undefined, { errors: ['User does not exist']})
    }
    else {
      callback(undefined, { errors: ['Unexpected Error'] })
    }
  })
  .catch(error => {
    callback(undefined, error);
  })
}

const sendChartDetails = (userId, chart, beingApproved, authHeaders, callback) => {
  showToast('Please wait...', 'success');
  var endPoint = beingApproved ? 'approve' : 'chart';
  request({
    url: '/api/v1/users/' + userId + '/'+ endPoint,
    headersToBeSent: authHeaders,
    method: 'POST',
    data: JSON.stringify(chart)
  })
  .then((response) => { callback(response, undefined); })
  .catch((error) => { callback(undefined, error); });
}

const searchChart = (query, entity, authHeaders, callback) => {
  request({
    url: '/api/v1/' + entity + '/?search[name]=' + query,
    headersToBeSent: authHeaders,
    method: 'GET'
  })
  .then((response) => { callback(response, undefined) })
  .catch((error) => { callback(undefined, error) })
}

const takeDosage = (...args) => {
  sendDosageDetails.apply(null, appendArguments(args, 'take'));
}

const snoozeAlert = (...args) => {
  sendDosageDetails.apply(null, appendArguments(args, 'snooze'));
}

const sendDosageDetails = (planGroupId, planId, token, callback, action) => {
  request({
    url: '/api/v1/treatment_plans/' + planGroupId + '/treatment_plan_therapies/' + planId + '/' + action,
    headersToBeSent: token,
    method: 'POST'
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) });
}

const getChartItems = (item, token, callback) => {
  request({
    url: '/api/v1/' + item + '/list',
    headersToBeSent: token,
    method: 'GET'
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

const changeOrphanPlanOwner = (...args) => {
  changeOrphanPlanState.apply(null, appendArguments(args, 'change_owner'));
}

const removeOrphanPlan = (...args) => {
  changeOrphanPlanState.apply(null, appendArguments(args, 'remove_treatment_plan'));
}

const changeOrphanPlanState = (planId, token, callback, endPoint) => {
  request({
    url: '/api/v1/treatment_plans/' + planId + '/' + endPoint,
    method: 'POST',
    headersToBeSent: token
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) });
}

const removeTpdRequests = (patient_id, token, callback) => {
  request({
    url: '/api/v1/user_survey_forms/remove_requests',
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify({ patient_id })
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) });
}
