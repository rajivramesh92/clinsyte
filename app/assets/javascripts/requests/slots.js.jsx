const getSlots = (params, token, callback) => {
  request({
    url: '/api/v1/physicians/' + params.id + '/slots',
    method: 'GET',
    headersToBeSent: token,
    data: params
  })
  .then(response => {
    callback(response, undefined)
  })
  .catch(error => {
    callback(undefined, error)
  })
}

const addSlot = (slot, token, callback) => {
  request({
    url: '/api/v1/slots',
    method: 'POST',
    headersToBeSent: token,
    data: JSON.stringify(slot)
  })
  .then(response => {
    callback(response, undefined)
  })
  .catch(error => {
    callback(undefined, error)
  })
}

const deleteSlot = (slotId, token, callback) => {
  request({
    url: '/api/v1/slots/' + slotId,
    method: 'DELETE',
    headersToBeSent: token
  })
  .then(response => {
    callback(response, undefined)
  })
  .catch(error => {
    callback(undefined, error)
  })
}

const updateSlot = (slotId, slot, token, callback) => {
  request({
    url: '/api/v1/slots/' + slotId,
    method: 'PUT',
    headersToBeSent: token,
    data: JSON.stringify(slot)
  })
  .then(response => {
    callback(response, undefined)
  })
  .catch(error => {
    callback(undefined, error)
  })
}
