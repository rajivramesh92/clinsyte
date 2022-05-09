var initialState = {};

const onSetRtParams = (state, action) => {
  var rtParams = _.omit({...action}, 'type')
  return {
    ...rtParams
  }
}

const onUnsetRtParams = (state, action) => {
  return {}
}

const rtParams = createReducer(initialState, {
  [SET_RTPARAMS]: onSetRtParams,
  [UNSET_RTPARAMS]: onUnsetRtParams
});
