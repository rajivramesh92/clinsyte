const sendSurvey = (token, params, method, callback, surveyId) => {
  request({
    url: '/api/v1/surveys/' + (surveyId || ''),
    method,
    headersToBeSent: token,
    data: JSON.stringify(params)
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

const getSurvey = (token, surveyId, callback) => {
  request({
    url: '/api/v1/surveys/' + surveyId,
    method: 'GET',
    headersToBeSent: token,
  })
  .then(response => { callback(response, undefined ) })
  .catch(error => { callback(undefined, error) })
}

const getSurveys = (page, token, callback, query) => {
  var search = [{
    key: 'name',
    value: query
  }];

  request({
    url: '/api/v1/surveys',
    method: 'GET',
    headersToBeSent: token,
    data: { page, search }
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

const getSurveyRequest = (token, requestId, callback) => {
  request({
    url: '/api/v1/user_survey_forms/' + requestId,
    method: 'GET',
    headersToBeSent: token
  })
  .then(response => { callback(response, undefined ) })
  .catch(error => { callback(undefined, error) })
}

const deleteSurvey = (token, surveyId, callback) => {
  request({
    url: '/api/v1/surveys/' + surveyId,
    method: 'DELETE',
    headersToBeSent: token
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

const sendSurveyRequest = (token, params, callback) => {
  request({
    url: '/api/v1/surveys/send_requests',
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify(params)
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

const sendResponse = (token, surveyId, params, callback) => {
  request({
    url: '/api/v1/surveys/' + surveyId + '/submit',
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify(params)
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

const startSurvey = (token, surveyId, params, callback) => {
  request({
    url: '/api/v1/surveys/' + surveyId + '/start',
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify(params)
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

const getSentRequests = (surveyId, options, token, callback) => {
  request({
    url: '/api/v1/surveys/' + surveyId + '/requests',
    method: 'GET',
    headersToBeSent: token,
    data: options
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

const getSurveyRequests = (options, token, callback) => {
  request({
    url: '/api/v1/user_survey_forms/requests',
    method: 'GET',
    headersToBeSent: token,
    data: options
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}
