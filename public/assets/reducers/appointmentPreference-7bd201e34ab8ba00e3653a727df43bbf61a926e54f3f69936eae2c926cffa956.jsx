const initialState = {}

const onSetAutoConfirm = (state, action) => {
  return {
    ...state,
    autoConfirm: true
  }
}

const onUnsetAutoConfirm = (state, action) => {
  return {
    ...state,
    autoConfirm: false
  }
}

const appointmentPreference = createReducer(initialState, {
  [SET_AUTO_CONFIRM]: onSetAutoConfirm,
  [UNSET_AUTO_CONFIRM]: onUnsetAutoConfirm
})
