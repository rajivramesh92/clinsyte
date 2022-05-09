const setCareteamRequests = (requests) => {
  return {
    type: SET_CARETEAM_REQUESTS,
    requests
  };
}

const addCareteamRequest = (request) => {
  return {
    type: ADD_CARETEAM_REQUEST,
    request
  };
}

const removeCareteamRequest = (recipientId) => {
  return {
    type: REMOVE_CARETEAM_REQUEST,
    recipientId
  };
}

const removeCareteamRequestUsingCareteamId = (careteamId) => {
  return {
    type: REMOVE_CARETEAM_REQUEST_USING_CARETEAMID,
    careteamId
  }
}
