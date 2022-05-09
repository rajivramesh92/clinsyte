const ResponseView = ({ question, response, serialNo }) => {

  const renderResponse = () => {
    if(question.category === PLAIN_TEXT) {
      return <i>{ response }</i>
    }
    else if (question.category === MULTIPLE_CHOICE) {
      return <McqResponseView response = { response }/>
    }
    else if (question.category === RANGE_BASED) {
      return (
        <RangeBasedResponseView id = { question.id }
          min = { question.attrs.min }
          max = { question.attrs.max }
          response = { response }
        />
      )
    }
    else if (question.category === LIST_BASED) {
      return (
        <div className = 'pull-left'>
          <span className = 'font-bold'>
            Option List:&nbsp;
          </span>
          { question.attrs.list.name }
          <ListBasedResponseView name = { question.id }
            selectedOptions = { response }
          />
        </div>
      );
    }
  }

  var textColor = question.status === 'inactive' ? 'text-muted ' : ''
  return (
    <div className = { textColor }>
      <div className = 'display-table-cell'>
        <span className = 'font-bold'>
          { serialNo }.&nbsp;
        </span>
      </div>
      <div className = 'vertically-centered full-width'>
        <div>
          <em className = 'blue small'>
            Question:&nbsp;
          </em>
          <span className = 'font-bold font-size-14'>
            { question.description }
          </span>
          { question.status === 'inactive' ? <em className = 'text-danger font-size-11'>&nbsp;(removed)</em> : '' }
        </div>
        <div>
          <em className = 'blue small pull-left full-width-in-mobile'>
            Response:&nbsp;
          </em>
          { response ? renderResponse() : <em className = 'font-size-11 strike'>(No response)</em> }
        </div>
      </div>
    </div>
  )
}

ResponseView.propTypes = {
  question: PropTypes.shape({
    id: PropTypes.oneOfType([
      PropTypes.number,
      PropTypes.string
    ]).isRequired,
    description: PropTypes.string.isRequired,
  }).isRequired,
  response: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.number,
      PropTypes.object,
      PropTypes.array
    ]).isRequired,
  serialNo: PropTypes.number
}
