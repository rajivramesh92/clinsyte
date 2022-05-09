const initialState = {}

const onLogin = (state, action) => {
  return {
    ...state,
    loggingin: true
  }
}

const onLoginSuccess = (state, action) => {
  return {
    ...state,
    loggingin: false,
    loginError: null,
    token: { ...action.data }
  }
}

const onLoginFailure = (state,action) => {
  return {
    ...state,
    loggingin: false,
    loginError: action.error
  }
}

const onSetAuthHeaders = (state,action) => {
  return {
    ...state,
    loggingin: false,
    loginError: null,
    token: { ...action.data }
  }
}

const onSignup = (state, action) => {
 return {
  ...state,
  signingup: true
 }
}

const onSignupSuccess = (state, action) => {
  return {
    ...state,
    signingup: false,
    signupError: null
  }
}

const onSignupFailure = (state, action) => {
  return {
    ...state,
    signingup: false,
    signupError: action.error
  }
}

const onSetUser = (state, action) => {
  return {
    ...state,
    user: action.data
  }
}

const onSetCurrentPhysician = (state, action) => {
  var user = Object.assign(state.user, { current_physician: action.physician });
  return {
    ...state,
    user: user
  }
}

const onLogout = (state, action) => {
  return {
    ...state,
    token: null,
    user: null
  }
}

const onPhoneNumberVerified = (state, action) => {
  var user = Object.assign({}, state.user, { phone_number_verified: true });
  return {
    ...state,
    user: user
  }
}

const onSetSignedInFirstTime = (state, data) => {
  return {
    ...state,
    signedInFirstTime: data.signedInFirstTime
  };
}

const auth = createReducer(initialState, {
  [SIGNUP]: onSignup,
  [SIGNUP_SUCCESS]: onSignupSuccess,
  [SIGNUP_FAILURE]: onSignupFailure,

  [LOGIN]: onLogin,
  [LOGIN_SUCCESS]: onLoginSuccess,
  [LOGIN_FAILURE]: onLoginFailure,

  [SET_AUTH_HEADERS]: onSetAuthHeaders,
  [SET_USER]: onSetUser,
  [SET_CURRENT_PHYSICIAN]: onSetCurrentPhysician,
  [SET_SIGNED_IN_FIRST_TIME]: onSetSignedInFirstTime,
  [PHONE_NUMBER_VERIFIED]: onPhoneNumberVerified,

  [LOGOUT]: onLogout
});
