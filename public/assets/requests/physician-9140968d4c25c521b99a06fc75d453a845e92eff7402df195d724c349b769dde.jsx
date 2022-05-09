const getSummary = (token, callback) => {
  request({
    url: '/api/v1/careteams/summary',
    method: 'GET',
    headersToBeSent: token
  })
  .then(response => callback(response, undefined))
  .catch(error => callback(undefined, error))
}
