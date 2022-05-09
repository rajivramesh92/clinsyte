const initialState = {
  imgString: ''
}

const onSetQR = (state, action) => {
  return {
    ...state,
    imgString: action.imgString
  }
}

const onUnsetQR = (state, action) => {
  return {
    ...state,
    imgString: ''
  }
}

const qrCode = createReducer(initialState, {
  [SET_QR]: onSetQR,
  [UNSET_QR]: onUnsetQR
});
