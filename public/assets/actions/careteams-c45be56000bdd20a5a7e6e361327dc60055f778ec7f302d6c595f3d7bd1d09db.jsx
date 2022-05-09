const setCareteams = (careteams) => {
  return {
    type: LOAD_CARETEAMS,
    careteams
  };
}

const removeCareteam = (careteamId) => {
  return {
    type: REMOVE_CARETEAM,
    careteamId
  }
}

const addCareteam = (careteam) => {
  return {
    type: ADD_CARETEAM,
    careteam
  }
}
