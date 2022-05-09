const setQRImgString = (imgString) => {
  return {
    type: SET_QR,
    imgString
  }
}

const unsetQRImgString = () => {
  return {
    type: UNSET_QR,
    imgString: ''
  }
}
