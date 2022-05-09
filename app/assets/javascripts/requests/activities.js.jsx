const getChartActivities = (userId, token,options, callback) => {
  getActivities('chart', userId, token, options, callback)
}

const getCareTeamActivities = (careteamId, token, options, callback) => {
  getActivities('careteam', careteamId, token, options, callback)
}

var getActivities = (entity, entityId, token, options, callback) => {
  request({
    url: '/api/v1' + getEntityActivityEndpoint(entity, entityId) + '/activities',
    method: 'GET',
    headersToBeSent: token,
    data: options
  })
  .then(response => {
    callback(response, undefined)
  })
  .catch (error => {
    callback(undefined, error)
  })
}

var getEntityActivityEndpoint = (entity, entityId) => {
  return entity === 'chart' ? '/users/' + entityId + '/chart' : '/careteams/' + entityId
}
