/** constants defining mode of QuestionView component */
const SPEC_MODE = 'specs';
const CHART_MODE = 'charts';

class QuestionView extends Component {

  constructor(props) {
    super(props);

    this.state = {
      mode: SPEC_MODE
    };

    this.handleOnChangeModeClick = this.handleOnChangeModeClick.bind(this);
  }

  handleOnChangeModeClick(event) {
    var mode = toggleValue([SPEC_MODE, CHART_MODE], this.state.mode);
    this.setState({ mode });
  }

  renderStatistics() {
    var question = this.props.question;
    var getQuestionStats = this.props.getQuestionStats;
    var token = this.props.token;
    var patients = this.props.patients;

    switch(question.category) {
      case MULTIPLE_CHOICE:
        return (
          <McqChart questionId = { question.id }
            getQuestionStats = { getQuestionStats }
            token = { token }
            patients = { patients }
          />
        );
      case RANGE_BASED:
        return (
          <RangeChart question = { question }
            getQuestionStats = { getQuestionStats }
            token = { token }
            patients = { patients }
          />
        );
      case LIST_BASED:
        return (
          <ListChart questionId = { String(question.id) }
            getQuestionStats = { getQuestionStats }
            token = { token }
            patients = { patients }
          />
        );
    }
  }

  renderSpecChangeButton() {
    var category = this.props.question.category
    if ( (category === MULTIPLE_CHOICE || category === RANGE_BASED || category === LIST_BASED) && this.props.getQuestionStats ) {
      var mode = this.state.mode;
      return (
        <button onClick = { this.handleOnChangeModeClick }
          className = 'btn btn-link link-btn blue pull-right no-padding'>
          { mode === SPEC_MODE ? 'statistics' : 'specifications' }
        </button>
      )
    }
  }

  renderChoice(choice) {
    return (
      <div className = 'form-group'
        key = { choice.id }>
        <div className = 'radio'>
          <input type = 'radio'
            disabled = { true }
            checked = { true }
          />
          { choice.option }
        </div>
      </div>
    )
  }

  renderSpecifications() {
    var question = this.props.question;
    if (question.category === MULTIPLE_CHOICE) {
      return renderItems(question.attrs, this.renderChoice)
    }
    else if (question.category === RANGE_BASED) {
      return (
        <SliderInput name = { question.id }
          min = { question.attrs.min }
          max = { question.attrs.max }
          customHandler = { true }
          disabled = { true }
          rangeClassName = 'margin-left-10 margin-right-10'
        />
      )
    }
    else if (question.category === LIST_BASED) {
      return (
        <div className = 'col-sm-6'>
          <label className = 'blue small'>
            { titleFromSnake(question.attrs.category) }
          </label>
          <select className = 'form-control'
            disabled = { true }>
            <option>
              { this.props.question.attrs.list.name }
            </option>
          </select>
        </div>
      );
    }
    else {
      return <em className = 'small text-muted'>No Spefications</em>
    }
  }

  render() {
    return (
      <div>
        { this.props.question.description }
        { this.renderSpecChangeButton() }
        <div>
          { this.state.mode === SPEC_MODE ? this.renderSpecifications() : this.renderStatistics() }
        </div>
      </div>
    )
  }
}

QuestionView.propTypes = {
  question: PropTypes.object.isRequired,
  getQuestionStats: PropTypes.func,
  token: PropTypes.object.isRequired,
  patients: PropTypes.array.isRequired
}
