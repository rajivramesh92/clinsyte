const setWelcome = (message) => {
  return {
    type: SET_WELCOME,
    message
  }
}

const unsetWelcome = () => {
  return {
    type: UNSET_WELCOME,
    message: ''
  }
}
