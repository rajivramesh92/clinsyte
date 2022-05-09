const initialState = [];

const onSetCareteamRequests = (state, data) => {
  return [...data.requests];
}

const onAddCareteamRequest = (state, data) => {
  return state.concat(data.request);
}

const onRemoveCareteamRequest = (state, data) => {
  return _.reject(state, request => {
    return request.recipient.id == data.recipientId;
  });
}

const onRemoveCareteamRequestUsingCareteamId = (state, data) => {
  return _.reject(state, request => {
    return request.recipient.careteam_id == data.careteamId;
  });
}

const careteamRequests = createReducer(initialState, {
  [ SET_CARETEAM_REQUESTS ]: onSetCareteamRequests,
  [ ADD_CARETEAM_REQUEST ]: onAddCareteamRequest,
  [ REMOVE_CARETEAM_REQUEST ]: onRemoveCareteamRequest,
  [ REMOVE_CARETEAM_REQUEST_USING_CARETEAMID ] : onRemoveCareteamRequestUsingCareteamId
});
