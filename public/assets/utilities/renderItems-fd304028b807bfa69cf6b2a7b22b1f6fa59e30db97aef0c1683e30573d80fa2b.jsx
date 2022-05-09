const renderItems = (items, getMarkup) => {
  return _.map(items, (item,index) => {
    return getMarkup(item,index);
  })
}
