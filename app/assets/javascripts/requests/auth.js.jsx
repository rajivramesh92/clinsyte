var headers = ['access-token', 'client', 'expiry', 'token-type', 'uid'];

const signup = (data, successCallback, errorCallback) => {
  request({ url: '/api/v1/users',
    method: 'POST',
    data: JSON.stringify(data)
  })
  .then(successCallback)
  .catch(errorCallback);
}

const login = (data, callback) => {
  request({
    url: '/api/v1/users/sign_in',
    method: 'POST',
    data: JSON.stringify(data),
    requiredHeaders: headers
  })
  .then(response => {
    callback(response,undefined);
  })
  .catch(error => {
    callback(undefined,error);
  })
}

const updateProfile = (data, userId, headers, callback) => {
  request({
    url: '/api/v1/users/' + userId,
    method: 'PUT',
    data: JSON.stringify({ user:data }),
    headersToBeSent: headers,
  })
  .then(response => {
    callback(response, undefined);
  })
  .catch(error => {
    callback(undefined, error);
  })
}

const initiateVerification = (data, token, successCallback, errorCallback) => {
  request({
    url: '/api/v1/users/confirmations/initiate_verification',
    method: 'POST',
    data: JSON.stringify(data),
    headersToBeSent: token
  })
  .then(response => {
    successCallback(response);
  })
  .catch(error => {
    errorCallback(error);
  });
}

const verifyPhoneNumber = (params, token, successCallback, errorCallback) => {
  request({
    url: '/api/v1/users/confirmations/phone_number?verification_token='+params.verification_token+'&phone_number='+params.phone_number,
    method: 'GET',
    headersToBeSent: token
  })
  .then(response => {
    successCallback(response);
  })
  .catch(error => {
    errorCallback(error);
  });
}

const sendVerificationCode = (data, successCallback, errorCallback) => {
  request({
    url: '/api/v1/users/passwords',
    method: 'POST',
    data: JSON.stringify(data)
  })
  .then(response => {
    successCallback(response);
  })
  .catch(error => {
    errorCallback(error);
  });
}

const validateVerificationCode = (data, successCallback, errorCallback) => {
  request({
    url: '/api/v1/users/passwords/validate_verification_code',
    method: 'POST',
    data: JSON.stringify(data)
  })
  .then(response => {
    successCallback(response);
  })
  .catch(error => {
    errorCallback(error);
  });
}

const resetPassword = (data, successCallback, errorCallback) => {
  request({
    url: '/api/v1/users/passwords/reset_password',
    method: 'POST',
    data: JSON.stringify(data)
  })
  .then(response => {
    successCallback(response);
  })
  .catch(error => {
    errorCallback(error);
  });
}

const deleteAccount = (data, userId, authHeaders, successCallback, errorCallback) => {
  request({
    url: '/api/v1/users/' + userId + '/destroy',
    method: 'POST',
    data: JSON.stringify(data),
    headersToBeSent: authHeaders
  })
  .then(successCallback)
  .catch(errorCallback);
}

const resendConfirmationEmail = (email, successCallback, errorCallback) => {
  var params = { email: email };
  request({
    url: '/api/v1/users/confirmations/resend',
    method: 'POST',
    data: JSON.stringify(params)
  })
  .then(successCallback)
  .catch(errorCallback);
}

const signOut = (token, successCallback, errorCallback) => {
  request({
    url: '/api/v1/users/sign_out',
    method: 'DELETE',
    headersToBeSent: token
  })
  .then(successCallback)
  .catch(errorCallback);
}
