const closeNotification = (key, token, successCallback, errorCallback) => {
  request({
    url: '/api/v1/notifications/ignore',
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify({ key: key })
  })
  .then(successCallback)
  .catch(errorCallback);
}
