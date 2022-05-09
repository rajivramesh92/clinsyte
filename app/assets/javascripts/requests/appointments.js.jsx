const createAppointment = ( params, token, successCallback, errorCallback ) => {
  request({
    url: '/api/v1/appointments',
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify({ appointment: params })
  }).
  then(successCallback).
  catch(errorCallback);
}

const getAppointments = ( token, successCallback, errorCallback ) => {
  request({
    url: '/api/v1/appointments',
    method: 'GET',
    headersToBeSent: token
  }).
  then(successCallback).
  catch(errorCallback);
}

const getAppointmentRequests = (token, callback) => {
  request({
    url: '/api/v1/appointments/pending',
    method: 'GET',
    headersToBeSent: token
  })
  .then(response => {
    callback(response, undefined)
  })
  .catch(error => {
    callback(undefined, error)
  })
}

const changeAppointmentStatus = (appointmentId, status, token, callback) => {
  request({
    url: '/api/v1/appointments/' + appointmentId + '/change_status',
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify({ status })
  })
  .then(response => {
    callback(response, undefined)
  })
  .catch(error => {
    callback(undefined, error)
  })
}

const cancelAppointment = (appointmentId, token, successCallback, errorCallback) => {
  request({
    url: '/api/v1/appointments/' + appointmentId + '/cancel',
    method: 'POST',
    headersToBeSent: token,
  })
  .then(successCallback)
  .catch(errorCallback);
}
