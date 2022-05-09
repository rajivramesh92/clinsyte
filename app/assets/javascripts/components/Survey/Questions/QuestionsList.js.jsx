class QuestionsList extends Component {

  constructor(props) {
    super(props)
    this.renderQuestion = this.renderQuestion.bind(this);
  }

  renderDelete(id) {
    return (
      <span className = 'cursor-pointer pull-right red'
        onClick = { this.props.onDelete(id) }>
        <Icon icon = { DELETE_ICON }/>
      </span>
    );
  }

  renderQuestion(question, index) {
    if(question.status !== 'inactive') {
      var props = this.props;
      return (
        <li key = { question.id }
          className = 'list-group-item'>
          <div className = 'row'>
            <div className = 'col-xs-11 left-padding-0 right-padding-0'>
              <div className = 'font-bold col-xs-1 left-padding-0 right-padding-0 text-right'>
                { index + 1 }.&nbsp;
              </div>
              <div className = 'col-xs-11 left-padding-0 right-padding-0'>
                <QuestionView question = { question }
                  token = { props.token }
                  getQuestionStats = { props.onDelete || !props.showStats ? null : props.getQuestionStats }
                  patients = { props.patients }
                />
              </div>
            </div>
            <div className = 'col-xs-1 left-padding-0 right-padding-0'>
              { this.props.onDelete ? this.renderDelete(question.id) : null }
            </div>
          </div>
        </li>
      )
    }
  }

  render() {
    return (
      <ul className = 'list-group'>
        { renderItems(this.props.questions, this.renderQuestion) }
      </ul>
    )
  }
}

QuestionsList.propTypes = {
  questions: PropTypes.array.isRequired,
  token: PropTypes.object,
  getQuestionStats: PropTypes.func,
  onDelete: PropTypes.func
}
