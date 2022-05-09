const configureScheduler = (params, token, type, callback) => {
  var endPoint = getEnpoint(type);
  request({
    url: '/api/v1/' + endPoint,
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify(params)
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

const getSchedules = (token, type, callback) => {
  var endPoint = getEnpoint(type);
  request({
    url: '/api/v1/' + endPoint,
    method: 'GET',
    headersToBeSent: token,
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

const deleteSchedule = (id, token ,type, callback) => {
  var endPoint = getEnpoint(type);
  request({
    url: '/api/v1/' + endPoint + '/' + id,
    method: 'DELETE',
    headersToBeSent: token
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) })
}

var getEnpoint = (type) => {
  return  type === 'eventDependent' ? 'event_dependent_surveys' : 'survey_configurations';
}
