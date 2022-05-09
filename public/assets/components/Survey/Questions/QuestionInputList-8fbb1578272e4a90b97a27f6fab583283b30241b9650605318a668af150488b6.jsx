class QuestionInputList extends Component {

  constructor(props) {
    super(props);
    this.state = {
      questions: []
    }
    this.handleOnAddClick = this.handleOnAddClick.bind(this);
    this.handleOnRemoveClick = this.handleOnRemoveClick.bind(this);
    this.renderQuestionInput = this.renderQuestionInput.bind(this);
    this.addClassName = this.getAddClassName(this.state.questions);
  }

  getAddClassName(questions) {
    return (_.isEmpty(questions) ? 'text-center font-size-18' : 'text-right font-size-12')
  }

  getQuestions() {
    return _.map(this.refs, ref => {
      return ref.getQuestion()
    })
  }

  clearQuestions() {
    this.setState({
      questions: []
    })
  }

  handleOnRemoveClick(index, questionId) {
    var questions = [];
    return (event) => {
      if(questionId) {
        questions = [...this.state.questions];
        questions[_.indexOf(questions, { id: questionId })]._destroy = true;
      }
      else {
        questions = _.toArray(_.omit(this.state.questions, index));
      }
      this.setState({
        questions
      })
    }
  }

  handleOnAddClick() {
    this.setState({
      questions: this.state.questions.concat({
        description: null
      })
    })
  }

  componentWillUpdate(nextProps, nextState) {
    this.addClassName = this.getAddClassName(nextState.questions);
  }

  renderQuestionInput(question, index) {
    if(!question._destroy) {
      return (
        <div key = { 'survey-question-' + index }
          className = 'margin-top-15'>
          <QuestionInput ref = { 'question' + index }
            serialNo = { index + 1}
            onRemove = { this.handleOnRemoveClick(index ,question.id) }
            lists = { this.props.lists }
          />
        </div>
      )
    }
  }

  renderQuestionInputs() {
    return renderItems(this.state.questions, this.renderQuestionInput)
  }

  render() {
    return (
      <div className = 'questions-list'>
        { this.renderQuestionInputs() }
        <div className = { 'margin-top-15 ' + this.addClassName }>
          <button className = 'btn-link survey-add-question'
          onClick = { this.handleOnAddClick }>
          <Icon icon = { ADD_ICON }/>&nbsp;Add Question
          </button>
        </div>
      </div>
    )
  }
}

