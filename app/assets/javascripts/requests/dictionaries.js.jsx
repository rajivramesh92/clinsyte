var listEndPoint = '/api/v1/lists';

const createList = (data, token, callback) => {
  request({
    url: listEndPoint,
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify(data)
  })
  .then( response => { callback(response, undefined); })
  .catch( error => { callback(undefined, error); });
}

const getLists = (token, callback) => {
  request({
    url: listEndPoint,
    method: 'GET',
    headersToBeSent: token
  })
  .then(response => { callback(response, undefined); })
  .catch(error => { callback(undefined, error); });
}

const deleteList = (listId, token, callback) => {
  request({
    url: listEndPoint + '/' + listId,
    method: 'DELETE',
    headersToBeSent: token,
  })
  .then( response => { callback(response, undefined); })
  .catch( error => { callback(undefined, error); });
}

const updateList = (listId, data, token, callback) => {
  request({
    url: listEndPoint + '/' + listId,
    method: 'PUT',
    headersToBeSent: token,
    data: JSON.stringify(data)
  })
  .then(response => { callback(response, undefined); })
  .catch(error => { callback(undefined, error) });
}
