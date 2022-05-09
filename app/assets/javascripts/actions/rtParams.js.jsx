const setRtParams = (rtParams) => {
  return {
    type: SET_RTPARAMS,
    ...rtParams
  }
}

const unSetRtParams = () => {
  return {
    type: UNSET_RTPARAMS
  }
}
