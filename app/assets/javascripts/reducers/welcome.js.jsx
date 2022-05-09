
const initialState = {
  message: ''
}

const onSetWelcome = (state, action) => {
  return {
    ...state,
    message: action.message
  }
}

const onUnSetWelcome = (state, action) => {
  return {
    ...state,
    message: ''
  }
}

const welcome = createReducer(initialState, {
  [SET_WELCOME]: onSetWelcome,
  [UNSET_WELCOME]: onUnSetWelcome
});
