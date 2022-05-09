const getTherapyProfileData = (therapyId, token, callback) => {
  request({
    url: '/api/v1/therapies/' + therapyId,
    method: 'GET',
    headersToBeSent: token,
  })
  .then(response => { callback(response, undefined) })
  .catch(error => { callback(undefined, error) });
}
