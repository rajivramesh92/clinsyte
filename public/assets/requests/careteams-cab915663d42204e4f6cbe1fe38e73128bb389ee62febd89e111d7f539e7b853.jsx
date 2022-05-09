const loadCareteams = (dispatch) => {
  var callback = (response) => {
    if( response.data && response.data.status == 'success' ){
      dispatch({
        type: LOAD_CARETEAMS,
        data: response.data.data
      });
    }
  }

  request({
    url : '/api/v1/careteams',
    method : 'GET',
    headersToBeSent: getToken()
  })
  .then(callback)
  .catch(callback);
}

const removeMemberFromCareteam = (params, token, successCallback, errorCallback) => {
  request({
    url : '/api/v1/careteams/' + params.careteamId + '/remove_member',
    method : 'POST',
    headersToBeSent: token,
    data: JSON.stringify({ member_id: params.memberId })
  })
  .then(successCallback)
  .catch(errorCallback);
}

const getCareteam = (patientId, token, callback) => {
  request({
    url : '/api/v1/patients/' + patientId + '/careteam',
    method: 'GET',
    headersToBeSent: token
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) });
}
