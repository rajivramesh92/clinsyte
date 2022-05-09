const loadCareteam = (careteam) => {
  return {
    type: LOAD_CARETEAM,
    careteam
  }
}

const addCareteamMember = (member) => {
  return {
    type: ADD_CARETEAM_MEMBER,
    member
  }
}

const removeCareteamMember = (memberId) => {
  return {
    type: REMOVE_CARETEAM_MEMBER,
    memberId
  }
}

const changePrimaryPhysician = (memberId) => {
  return {
    type: CHANGE_PRIMARY_PHYSICIAN,
    memberId
  }
}
