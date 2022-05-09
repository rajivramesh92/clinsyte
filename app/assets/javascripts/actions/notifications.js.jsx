const setNotifications = (notifications) => {
  return {
    type: LOAD_NOTIFICATIONS,
    notifications
  };
}

const unsetNotification = (key) => {
  return {
    type: REMOVE_NOTIFICATION,
    key
  };
}
