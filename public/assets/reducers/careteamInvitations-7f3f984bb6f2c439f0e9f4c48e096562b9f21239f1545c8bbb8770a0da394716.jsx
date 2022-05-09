const initialState = [];

var onRemoveCareteamInvite = (state, data) => {
  return remove(state, (element) => {
    return element.id == data.inviteId;
  });
}

const onLoadCareteamInvites = (state, data) => {
  return Object.assign([], data.careteamInvitations);
}

const careteamInvitations = createReducer(initialState, {
  [REMOVE_CARETEAM_INVITE]: onRemoveCareteamInvite,
  [LOAD_CARETEAM_INVITES] : onLoadCareteamInvites
});
