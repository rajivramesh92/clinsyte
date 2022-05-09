class ResponseList extends Component {

  constructor(props) {
    super(props);
    this.getResponses = this.getResponses.bind(this);
    this.getStatus = this.getStatus.bind(this);
    this.renderResponse = this.renderResponse.bind(this);
  }

  getResponses() {
    return responses =  _.map(this.refs, (response, id) => {
      return {
        ques_id: id,
        response: response.getResponse()
      }
    })
  }

  getStatus(questionId){
    if( this.refs[questionId] ) {
      var response = this.refs[questionId].getResponse();
      response = Array.isArray(response) ? response : [ response ];
      if(_.isEmpty(_.compact(response))) {
        return (
          <span className = 'red answer-validity'>
            <Icon icon = { INVALID_ANSWER_ICON } />
          </span>
        );
      }
      else {
        return (
          <span className = 'green answer-validity'>
            <Icon icon = { VALID_ANSWER_ICON } />
          </span>
        );
      }
    }
    return null;
  }

  renderResponse(question, index) {
    return (
      <div key = { question.id }
        className = 'list-group-item'>
        { this.getStatus(question.id) }
        <Response question = { question }
          ref = { question.id }
          serialNo = { index + 1 }
        />
      </div>
    )
  }

  render() {
    return (
      <div className = 'list-group'>
        { renderItems(this.props.questions, this.renderResponse) }
      </div>
    )
  }
}

ResponseList.propTypes = {
  questions: PropTypes.array.isRequired
}
