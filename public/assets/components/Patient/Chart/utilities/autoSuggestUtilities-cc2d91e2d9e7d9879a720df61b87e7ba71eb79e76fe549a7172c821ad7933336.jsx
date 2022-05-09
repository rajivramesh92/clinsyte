const getAutoSuggestEngine = (item, property) => {
  return React.renderToString(
    <div className = 'col-xs-12 chart-suggestion'>
      { item[property] }
    </div>
  )
}
