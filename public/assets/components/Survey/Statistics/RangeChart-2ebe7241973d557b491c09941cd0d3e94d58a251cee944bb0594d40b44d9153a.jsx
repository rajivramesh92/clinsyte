class RangeChart extends Component {

  constructor(props) {
    super(props);

    this.state = {
      type: WHISKERS_PLOT,
      stats: null,
      isLoading: true,
      selectedPatient: null
    }

    this.dataType = {
      [WHISKERS_PLOT]: WHISKERS_CHART_DATA,
      [STACKED_BAR_CHART]: RANGE_FREQUENCIES,
      [DISTRIBUTION_CURVE]: RANGE_FREQUENCIES
    };

    this.types = [WHISKERS_PLOT, DISTRIBUTION_CURVE];

    var attrs = this.props.question.attrs;

    if(attrs.max - attrs.min <= STACKED_RANGE_MAX_DIFF) {
      this.types.push(STACKED_BAR_CHART);
    }

    this.handleTypeChange = this.handleTypeChange.bind(this);
    this.handleSelectedPatientChange = this.handleSelectedPatientChange.bind(this);
  }

  componentDidMount() {
    this.updateChart(WHISKERS_PLOT, this.state.selectedPatient, true);
  }

  updateChart(type, selectedPatient, load = false) {
    load ? this.loadStats(type, this.dataType[type], selectedPatient) : this.setState({ type, selectedPatient })
  }

  loadStats(type, dataType, selectedPatient) {
    var id = this.props.question.id;
    var token = this.props.token;

    this.setState({ isLoading: true });

    this.props.getQuestionStats(id, dataType, selectedPatient, token, stats => {
      this.setState({
        stats,
        type,
        selectedPatient,
        isLoading: false
      })
    });
  }

  getStackData() {
    var stats = this.state.stats;

    var headers = ['Population'].concat(_.keys(stats[_.first(_.keys(stats))]));
    var rows = _.map(_.pairs(stats), pair => {
      return [titleFromSnake(_.first(pair))].concat(_.values(_.last(pair)));
    });

    return [headers].concat(rows);
  }

  getCurveData() {
    var stats = this.state.stats;

    var firstRow = _.union(['Values'],(_.map(_.keys(stats), titleFromSnake)));

    var allValues = _.keys(stats[_.first(_.keys(stats))]);
    var allFrequencies = _.map(stats, _.values);
    var otherRows = _.zip.apply(null, _.union([allValues], allFrequencies));

    return _.union([firstRow], otherRows);
  }

  getWhiskersData() {
    var stats = this.state.stats;
    return _.map(stats, (response, item) => {

      return [
        titleFromSnake(item),
        response.min,
        response.first_quartile,
        response.median,
        response.third_quartile,
        response.max
      ];

    });
  }

  getTypeOptions() {
    return _.map(this.types, type => {
      return {
        key: type,
        value: type,
        display: titleFromSnake(type)
      }
    });
  }

  handleSelectedPatientChange(selectedPatient) {
    if(this.state.selectedPatient != selectedPatient) {
      this.updateChart(this.state.type, selectedPatient, true);
    }
  }

  handleTypeChange(type) {
    var thirdType = _.difference(this.types, [this.state.type, type])[0];
    var selectedPatient = this.state.selectedPatient;

    if(thirdType === WHISKERS_PLOT) {
      this.updateChart(type, selectedPatient)
    }
    else {
      this.updateChart(type, selectedPatient, true);
    }

  }

  renderErrors(errors) {
    return renderItems(errors, (error, index) => {
      return (
        <p key = { index }
         className = 'red small'>
          { error }
        </p>
      );
    });
  }

  renderStackedBarChart() {
    var id = this.props.question.id;
    var stats = this.state.stats;

    if(stats.error) {
      return this.renderErrors([stats.error]);
    }
    return (
      <StackedBarChart name = { id + 'stackedBarChart'}
        data = { this.getStackData() }
        title = 'Stacked bar chart'
      />
    );
  }

  renderDistributionCurve() {
    var id = this.props.question.id;
    var stats = this.state.stats;

    if(stats.error) {
      return this.renderErrors([stats.error]);
    }
    return (
      <DistributionCurve name = { id + 'distributionCurve'}
        data = { this.getCurveData() }
        title = 'Distribution Curve'
      />
    );
  }

  renderWhiskersPlot() {
    var id = this.props.question.id;
    var stats = this.state.stats;

    var errors = _.map(stats, (response, item) => {
      if(response.error) {
        return 'In ' + titleFromSnake(item) + ' ' + response.error;
      }
    });

    return (
      <div>
        { this.renderErrors(errors) }
        <WhiskerPlot name = { id + 'whiskersPlot'}
          data ={ this.getWhiskersData() }
        />
      </div>
    );
  }

  renderChart() {
    switch(this.state.type) {
      case WHISKERS_PLOT:
        return this.renderWhiskersPlot();
      case DISTRIBUTION_CURVE:
        return this.renderDistributionCurve();
      case STACKED_BAR_CHART:
        return this.renderStackedBarChart();
    }
  }

  renderPatientSelect() {
    return (
      <div>
        <label className = 'font-bold blue'>
          Select Patient
        </label>
        <PatientSelect onChange = { this.handleSelectedPatientChange }
          patients = { this.props.patients }
          className = 'full-width'
        />
      </div>
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
          <label className = 'font-bold blue'>
            Select Chart
          </label>
          <DropDown onChange = { this.handleTypeChange }
            options = { this.getTypeOptions() }
            className = 'full-width'
          />
        </div>
        <div className = 'col-xs-12 margin-top-7'>
          { isLoading ? <PreLoader visible = { true }/> : this.renderChart() }
        </div>
      </div>
    )
  }
}

RangeChart.propTypes = {
  patients: PropTypes.array.isRequired,
  getQuestionStats: PropTypes.func.isRequired,
  token: PropTypes.object.isRequired,
  question: PropTypes.object.isRequired
}
