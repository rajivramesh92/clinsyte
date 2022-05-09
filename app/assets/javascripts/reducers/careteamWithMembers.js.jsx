var initialState = {};

const onLoadCareteam = (state, data) => {
  return Object.assign(initialState, data.careteam);
}

const onAddCareteamMember = (state, data) => {
  var newState = _.clone(state);
  newState.members.push(data.member);
  return newState;
}

const onRemoveCareteamMember = (state, data) => {
  var newState = _.clone(state);
  newState.members = remove(newState.members, (element) => {
    return element.id == data.memberId;
  }.bind(this));
  return newState;
}

const onChangePrimaryPhysician = (state, data) => {
  var currentIndex = _.findIndex(state.members, { id: data.memberId });
  var primaryIndex = _.findIndex(state.members, { careteam_role: 'primary' });
  var members = [...state.members];
  members[currentIndex].careteam_role = 'primary';
  members[primaryIndex].careteam_role = 'basic';

  return {
    members
  }
}

const careteamWithMembers = createReducer(initialState, {
  [ LOAD_CARETEAM ] : onLoadCareteam,
  [ ADD_CARETEAM_MEMBER ] : onAddCareteamMember,
  [ REMOVE_CARETEAM_MEMBER ] : onRemoveCareteamMember,
  [ CHANGE_PRIMARY_PHYSICIAN ] : onChangePrimaryPhysician
});
