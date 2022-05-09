const getGraphData = (id, params, token, callback) => {
  request({
    url: '/api/v1/questions/' + id + '/statistic',
    method: 'GET',
    data: params,
    headersToBeSent: token
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) });
}
