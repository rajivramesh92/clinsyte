class McqChart extends Component {

  constructor(props) {
    super(props);

    this.state = {
      type: PIE_CHART,
      stats: null,
      selectedPatient: null,
      isLoading: true
    }

    this.handleTypeChange = this.handleTypeChange.bind(this);
    this.handleSelectedPatientChange = this.handleSelectedPatientChange.bind(this);
  }

  componentDidMount() {
    this.loadChart(null);
  }

  loadChart(selectedPatient) {
    var id = this.props.questionId;
    var token = this.props.token;
    var type = this.state.type;

    this.setState({ isLoading: true })

    this.props.getQuestionStats(id, MCQ_OPTION_COUNTS, selectedPatient, token, stats => {
      this.setState({
        stats,
        selectedPatient,
        isLoading: false
      })
    });
  }

  getStackedChartData() {
    var stats = this.state.stats;

    var headers = ['Population'].concat(_.map(stats[_.first(_.keys(stats))], choice => {
      return choice.option.option;
    }));

    var rows = _.map(_.pairs(stats), pair => {

      var title = titleFromSnake(_.first(pair));
      var optionCounts = _.map(_.last(pair), 'count');

      return [title].concat(optionCounts);
    });

    return [headers].concat(rows);
  }

  getTypeOptions() {
    types = [PIE_CHART, STACKED_BAR_CHART];
    return _.map(types, type => {
      return {
        key: type,
        value: type,
        display: titleFromSnake(type)
      }
    })
  }

  handleSelectedPatientChange(selectedPatient) {
    this.loadChart(selectedPatient);
  }

  handleTypeChange(type) {
    this.setState({ type })
  }

  renderPieChart() {
    var id = this.props.questionId;
    var stats = _.mapObject({...this.state.stats}, response => {
      return [PIE_CHART_HEADING].concat(_.map(response, item => {
        return [item.option.option, item.count];
      }));
    });
    _.each(_.keys(stats), key => {
      stats[camelFromSnake(key)] = stats[key];
      delete stats[key];
    });
    return (
      <OptionCountPieChart id = { id }
        stats = { stats }
      />
    );
  }

  renderStackedBarChart() {
    var id = this.props.questionId;
    return (
      <StackedBarChart name = { id + 'stackedBarChart' }
        title = 'Stacked Bar Chart'
        data = { this.getStackedChartData() }
      />
    )
  }

  renderChart() {
    switch(this.state.type) {
      case PIE_CHART:
        return this.renderPieChart();
      case STACKED_BAR_CHART:
        return this.renderStackedBarChart();
    }
  }

  renderPatientSelect() {
    return (
      <PatientSelect patients = { this.props.patients }
        onChange = { this.handleSelectedPatientChange }
        className = 'full-width'
      />
    );
  }

  render() {
    var isLoading = this.state.isLoading;
    return (
      <div className = 'row margin-top-40'>
        <div className = 'col-sm-5 margin-top-7'>
          { _.isEmpty(this.props.patients) ? '' : this.renderPatientSelect() }
        </div>
        <div className = 'col-sm-3 margin-top-7'>
          <DropDown onChange = { this.handleTypeChange }
            options = { this.getTypeOptions() }
            className = 'full-width'
          />
        </div>
        <div className = 'col-xs-12 margin-top-7'>
          { isLoading ? <PreLoader visible = { true } /> : this.renderChart() }
        </div>
      </div>
    )
  }
}

McqChart.propTypes = {
  patients: PropTypes.array.isRequired,
  getQuestionStats: PropTypes.func.isRequired,
  questionId: PropTypes.oneOfType([
    PropTypes.string, PropTypes.number
  ]).isRequired,
  token: PropTypes.object.isRequired
}
