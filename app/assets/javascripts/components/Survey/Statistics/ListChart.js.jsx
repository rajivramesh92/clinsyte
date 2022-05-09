class ListChart extends Component {

  constructor(props) {
    super(props);

    this.state = {
      stats: null,
      selectedPatient: null,
      isLoading: true
    }

    this.handleSelectedPatientChange = this.handleSelectedPatientChange.bind(this);
  }

  componentDidMount() {
    this.loadChart(null);
  }


  loadChart(selectedPatient) {
    var id = this.props.questionId;
    var token = this.props.token;

    this.setState({
      isLoading: true
    });

    this.props.getQuestionStats(id, LIST_OPTION_COUNTS, selectedPatient, token, stats => {
      this.setState({
        stats,
        selectedPatient,
        isLoading: false
      });
    });
  }

  handleSelectedPatientChange(selectedPatient) {
    this.loadChart(selectedPatient);
  }

  renderChart() {
    var id = this.props.questionId;
    var stats = _.mapObject(this.state.stats, response => {
      return [PIE_CHART_HEADING].concat(_.map(response, item => {
        return [item.option, item.count];
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
        <div className = 'col-xs-12 margin-top-7'>
          { isLoading ? <PreLoader visible = { true } /> : this.renderChart() }
        </div>
      </div>
    );
  }
}

ListChart.propTypes = {
  patients: PropTypes.array.isRequired,
  getQuestionStats: PropTypes.func.isRequired,
  questionId: PropTypes.string.isRequired,
  token: PropTypes.object.isRequired
}
