createReducer = (initialState, handlers) => {
  return (state = initialState, action) => {
    var handler = handlers[action.type];
    if(handler) {
      return handler(state, action)
    }
    return state;
  }
}
