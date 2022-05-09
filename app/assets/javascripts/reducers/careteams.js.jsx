const initialState = [];

const onLoadCareteams = (state, data) => {
  return _extends([], data.careteams);
}

const onRemoveMember = (state, data) => {
  return remove(state, function(careteam){
    return ( careteam.id == data.careteamId );
  }.bind(this));
}

const onAddCareteam = (state, data) => {
  return [...state].concat(data.careteam)
}

const careteams = createReducer(initialState, {
  [LOAD_CARETEAMS] : onLoadCareteams,
  [REMOVE_CARETEAM] : onRemoveMember,
  [ADD_CARETEAM] : onAddCareteam
});
