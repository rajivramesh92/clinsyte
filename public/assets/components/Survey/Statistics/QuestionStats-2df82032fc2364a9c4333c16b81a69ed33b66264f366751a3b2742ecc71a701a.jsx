class QuestionStats extends Component {

  constructor(props) {
    super(props);

    this.state = {
      stats: null,
      isLoading: true
    }
  }

  componentDidMount() {
    var props = this.props;
    props.getQuestionStats(props.questionId, props.token, stats => {
      this.setState({
        stats,
        isLoading: false
      })
    })
  }

  renderChart() {
    var stats = this.state.stats;
    var questionId = this.props.questionId;

    switch(this.props.chart) {
      case MCQ_CHART:
        return (
          <McqChart stats = { stats }
            id = { questionId }
          />
        )
      case RANGE_CHART:
        return (
          <RangeChart stats = { stats }
            patients = { this.props.patients }
          />
        )
    }

  }

  render() {
    var isLoading = this.state.isLoading;
    return (
      <div>
        { isLoading ? <PreLoader visible = { true } /> : this.renderChart() }
      </div>
    )
  }
}

QuestionStats.propTypes = {
  chart: PropTypes.string.isRequired,
  getQuestionStats: PropTypes.func.isRequired,
  questionId: PropTypes.oneOfType([
    PropTypes.string, PropTypes.number
  ]).isRequired,
  token: PropTypes.object.isRequired
}
