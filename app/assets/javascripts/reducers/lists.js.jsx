var initialState = {};

const onSetLists = (state, action) => {
  return action.lists ? [...action.lists] : [];
}

const onUnsetLists = (state, action) => {
  return [];
}

const lists = createReducer(initialState, {
  [SET_LISTS]: onSetLists,
  [UNSET_LISTS]: onUnsetLists
});
