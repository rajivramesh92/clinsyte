const setLists = (lists) => {
  return {
    type: SET_LISTS,
    lists
  }
}

const unsetLists = () => {
  return {
    type: UNSET_LISTS
  }
}
