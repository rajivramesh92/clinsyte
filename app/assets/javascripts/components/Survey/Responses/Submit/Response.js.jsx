class Response extends Component {

  getResponse() {
    return this.refs.response.getResponse();
  }

  render() {
    var props = this.props;
    var question = props.question;
    return (
      <div className = { 'form-group ' + props.className }>
        <div>
          { props.serialNo }.&nbsp;
          <span className = 'font-bold font-size-14'>
            { question.description }
          </span>
        </div>
          <em className = 'blue small'>
            Your response
          </em>
          <CategoryResponse ref = 'response'
            category = { question.category }
            inputClassName = { this.props.inputClassName }
            question = { question }
          />
      </div>
    )
  }
}

Response.propTypes = {
  question: PropTypes.shape({
    id: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.number
    ]).isRequired,
    description: PropTypes.string.isRequired,
    category: PropTypes.oneOf(QUESTION_CATEGORIES).isRequired
  }).isRequired,
  className: PropTypes.string,
  inputClassName: PropTypes.string
}
