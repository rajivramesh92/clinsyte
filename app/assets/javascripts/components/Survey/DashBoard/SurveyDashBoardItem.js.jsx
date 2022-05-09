/** constants defining mode of QuestionView component */
const SPEC_MODE = 'specs';
const CHART_MODE = 'charts';

class SurveyDashBoardItem extends Component {

  constructor(props) {
    super(props);
    var category = props.question.category;
    this.CHART_HAVING_CATEGORIES = [MULTIPLE_CHOICE, RANGE_BASED, LIST_BASED];

    this.state = {
      mode: _.contains(this.CHART_HAVING_CATEGORIES, category) ? CHART_MODE : SPEC_MODE
    };

    this.handleOnChangeModeClick = this.handleOnChangeModeClick.bind(this);
  }

  handleOnChangeModeClick(event) {
    var mode = toggleValue([SPEC_MODE, CHART_MODE], this.state.mode);
    this.setState({ mode });
  }

  renderStatistics() {
    var { question, getQuestionStats, token, patients } = this.props;

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
    if (_.contains(this.CHART_HAVING_CATEGORIES, category)) {
      var mode = this.state.mode;
      var icon = (mode === SPEC_MODE ? CARET_UP : CARET_DOWN);
      return (
        <button onClick = { this.handleOnChangeModeClick }
          className = 'btn btn-link link-btn blue pull-right no-padding'>
          specifications <Icon icon = { icon }/>
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
    var mode = this.state.mode;
    return (
      <div>
        <div className = 'row'>
          <div className = 'col-xs-12'>
            { this.renderSpecChangeButton() }
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-xs-12'>
            { mode === SPEC_MODE ? <div><em>Spefications:&nbsp;</em>{ this.renderSpecifications() }</div> : '' }
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-xs-12'>
            { this.renderStatistics() }
          </div>
        </div>
      </div>
    )
  }
}

SurveyDashBoardItem.propTypes = {
  question: PropTypes.object.isRequired,
  getQuestionStats: PropTypes.func,
  token: PropTypes.object.isRequired,
  patients: PropTypes.array.isRequired
}
