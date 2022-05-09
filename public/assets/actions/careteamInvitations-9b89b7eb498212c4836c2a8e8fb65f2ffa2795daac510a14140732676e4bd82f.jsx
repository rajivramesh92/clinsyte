const setCareteamInvites = (careteamInvitations) => {
  return {
    type: LOAD_CARETEAM_INVITES,
    careteamInvitations
  };
}

const removeCareteamInvite = (inviteId) => {
  return {
    type: REMOVE_CARETEAM_INVITE,
    inviteId
  }
}
