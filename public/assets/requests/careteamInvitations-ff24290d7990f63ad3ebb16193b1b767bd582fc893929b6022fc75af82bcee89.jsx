const inviteUpdater  = (params, token) => {
  request({
    url: '/api/v1/requests/' + params.inviteId,
    method: 'PUT',
    headersToBeSent: token,
    data: JSON.stringify({ status: params.action })
  })
  .then(params.successCallback)
  .catch(params.errorCallback);
}

const acceptCareteamInvite = (inviteId, token, successCallback, errorCallback) => {
  inviteUpdater({
    action: 'accept',
    inviteId: inviteId,
    successCallback: successCallback,
    errorCallback: errorCallback
  }, token)
}

const declineCareteamInvite = (inviteId, token, successCallback, errorCallback) => {
  inviteUpdater({
    action: 'decline',
    inviteId: inviteId,
    successCallback: successCallback,
    errorCallback: errorCallback
  }, token)
}

const createCareteamInvite = (recipientId, token, callback) => {
  request({
    url: '/api/v1/requests',
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify({ recipient_id: recipientId })
  })
  .then( response => { callback(response, undefined) })
  .catch( error => { callback(undefined, error) });
}
