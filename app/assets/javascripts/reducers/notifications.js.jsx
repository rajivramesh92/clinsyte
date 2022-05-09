const initialState = [];

const onLoadNotifications = (state, data) => {
  return _extends([], data.notifications);
}

const onRemoveNotification = (state, data) => {
  return remove(state, function(notification){
    return ( notification.type == data.key );
  }.bind(this));
}

const onMarkAsRead = (state, action) => {
  return { ...state };
}

const onMarkAllNotificationsRead = (state, action) => {
  return {
    ...state,
    count: 0,
    error: null
  }
}

const onNotificationError = (state,action) => {
  return {
    ...state,
    count: 0,
    error: action.error
  }
}

const notifications = createReducer(initialState, {
  [LOAD_NOTIFICATIONS]: onLoadNotifications,
  [REMOVE_NOTIFICATION]: onRemoveNotification,
  [MARK_NOTIFICATION_AS_READ]: onMarkAsRead,
  [MARK_ALL_NOTIFICATIONS_READ]: onMarkAllNotificationsRead
})
