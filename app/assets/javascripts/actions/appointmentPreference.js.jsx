const toggleAutoConfirm = (autoConfirm) => {
  switch(autoConfirm) {
    case true:
    return {
      type: SET_AUTO_CONFIRM
    }
    case false:
    return {
      type: UNSET_AUTO_CONFIRM
    }
  }
}