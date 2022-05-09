const makePrimary = (id, token, callback) => {
  request({
    url: 'api/v1/physicians/' + id + '/make_primary',
    method: 'POST',
    headersToBeSent: token
  })
  .then(response => {
    callback(response, undefined)
  })
  .catch(error => {
    callback(undefined, error)
  })
}
