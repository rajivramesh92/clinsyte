const setAuthHeaders = (headers) => {
  return {
    type: SET_AUTH_HEADERS,
    data: headers
  }
}

const setUser = (user) => {
  return {
    type: SET_USER,
    data: user
  }
}

const setLogInError = (error) => {
  return {
    type: LOGIN_FAILURE,
    data: error
  }
}

const setSignUpSuccess = () => {
  return {
    type: SIGNUP_SUCCESS
  }
}

const setLogInSuccess = (headers) => {
  return {
    type: LOGIN_SUCCESS,
    data: headers
  }
}

const setSignUpError = (error) => {
  return {
    type: SIGNUP_FAILURE,
    data: error
  }
}

const setSignedInFirstTime = (signedInFirstTime) => {
  return {
    type: SET_SIGNED_IN_FIRST_TIME,
    signedInFirstTime
  }
}

const setLogoutSuccess = () =>{
  return {
    type: LOGOUT
  };
}

const setSignUp = () => {
  return {
    type: SIGNUP
  }
}

const setPhoneNumberVerified = () => {
  return {
    type: PHONE_NUMBER_VERIFIED
  }
}
