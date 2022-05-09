const updateAutoConfirm = (autoConfirm, token, callback) => {
  request({
    url: '/api/v1/appointment_preferences/toggle_auto_confirm',
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify({appointment_preference : { auto_confirm: autoConfirm } })
  })
  .then(response => {
    callback(response, undefined)
  })
  .catch(error => {
    callback(undefined, error)
  })
}
