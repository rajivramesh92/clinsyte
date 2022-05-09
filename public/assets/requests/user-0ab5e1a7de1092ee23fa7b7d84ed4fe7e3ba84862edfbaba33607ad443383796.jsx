const getBasicProfile = (userId, token, successCallback, errorCallback) => {
  request({
    url: '/api/v1/users/' + userId,
    method: 'GET',
    headersToBeSent: token
  })
  .then(successCallback)
  .catch(errorCallback);
}

const listUsers = (query, token, callback) => {
  request({
    url: '/api/v1/users/search',
    data: getData(query),
    headersToBeSent: token
  })
  .then( response => { callback(response, undefined) })
  .catch( error => { callback(undefined, error) });
}

var getData = (query) => {
  return {
    search: [
      {
        key: 'first_name',
        value: query.value
      },
      {
        key: 'last_name',
        value: query.value
      }
    ],
    roles: query.roles
  };
}
