var mapStateToProps = (state) => {
  return {
    notifications: state.notifications,
    token: state.auth.token
  }
}

var mapDispatchToProps = (dispatch) => {
  return {
    onRemove: (key, token) => {
      var successCallback = (response) => {
        if (!(response instanceof String) && (response.data.status == 'success')){
          dispatch(unsetNotification(key));
        }
      }

      var errorCallback = (error) => {
        console.log(error);
      }
      closeNotification(key, token, successCallback, errorCallback);
    }
  }
}

NotificationListManager = connect(mapStateToProps, mapDispatchToProps)(NotificationList);
