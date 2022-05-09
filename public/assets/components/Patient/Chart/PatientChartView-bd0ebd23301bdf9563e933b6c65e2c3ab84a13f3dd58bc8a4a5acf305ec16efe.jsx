class PatientChartView extends Component {

	constructor(props) {
		super(props);
		this.state = {
			chart: null,
      mode: 'view',
      showTpDeleteWarning: false,
      showDeleteAllRequestsWarning: false,
      deletingPlan: null
		}
    this.handleOnUpdateClick = this.handleOnUpdateClick.bind(this);
    this.handleOnApproveClick = this.handleOnApproveClick.bind(this);
    this.handleChangeInConditions = this.handleChangeInConditions.bind(this);
    this.handleTpDeleteWarningClose = this.handleTpDeleteWarningClose.bind(this);
    this.handleDeleteAllRequestsWarningClose = this.handleDeleteAllRequestsWarningClose.bind(this);
    this.changeMode = this.changeMode.bind(this);
    this.takeDosage = this.takeDosage.bind(this);
    this.removeOrphanPlan = this.removeOrphanPlan.bind(this);
    this.approveOrphanPlan = this.approveOrphanPlan.bind(this);
    this.renderTreatmentPlans = this.renderTreatmentPlans.bind(this);
    this.removeTpdRequests = this.removeTpdRequests.bind(this);
	}

  componentDidMount() {
    this.getPatientChartData();
  }

  takeDosage(planGroupId, planId) {
    var token = this.props.token;
    this.props.takeDosage(planGroupId, planId, token);
  }

  changeMode(mode) {
    return (event) => {
      event.preventDefault();
      this.setState({
        mode
      })
    }
  }

  approveOrphanPlan(planId) {
    this.props.approveOrphanPlan(planId, this.props.token, plan => {
      var stateChart = this.state.chart
      var mode = 'view';
      var chart = {
        ...stateChart,
        treatment_plans: _.reject([...stateChart.treatment_plans], { id: plan.id }).concat(plan)
      }
      this.setState({ mode, chart });
    });
  }

  removeOrphanPlan(planId) {
    this.setState({
      showTpDeleteWarning: true,
      deletingPlan: planId
    });
  }

  allSymptoms(chart) {
    return uniqObjects(_.flatten(_.filter(_.map(chart.conditions, 'symptoms')), 'id'));
  }

  getPatientChartData() {
    getChartDetails(this.props.params.id, this.props.token, (response, error) => {
      if(response) {
        this.setState({
          chart: response.data.data
        })
      }
      else {
        showToast(SOMETHINGWRONG,'error');
      }
    })
  }

  handleChangeInConditions(conditions) {
    this.setState({
      chart: {
        ...this.state.chart,
        conditions
      }
    });
  }

  removeTpdRequests() {
    var { removeTpdRequests, params, token, user } = this.props;
    removeTpdRequests(params.id, token, (requestsRemoved, dispatch) => {
      var chart = {
        ...this.state.chart,
        pending_tpd_surveys: !requestsRemoved
      };
      if ( isPatient(user)) {
        dispatch(removeTPDSurveys());
      }
      this.setState({ chart });
    })
  }

  renderTreatmentPlans() {
    var { chart, mode } = this.state;
    var { token, user, searchChart, params } = this.props;
    var { approveOrphanPlan, removeOrphanPlan, allSymptoms, takeDosage, removeTpdRequests } = this;
    var partitionedPlans = _.partition(chart.treatment_plans, plan => plan.creator.id == user.id);

    var showDeleteAllRequestsWarning = () => {
      this.setState({
        showDeleteAllRequestsWarning: true
      });
    }

    if (mode === 'view' && _.isEmpty(chart.treatment_plans)) {
      return (
        <div className='text-center text-muted'>
          <i>No treatment plans have been added</i>
        </div>
      );
    }

    if (mode === 'edit' && chart.pending_tpd_surveys) {
      return (
        <PendingSurveyWarning onDeleteClick = { showDeleteAllRequestsWarning }
          userPatient = { user.id == params.id }
        />
      );
    }

    return (
      <div>
        <TreatmentPlansGroup planGroups = { mode === 'edit' ? _.last(partitionedPlans) : chart.treatment_plans }
          takeDosage = { takeDosage }
          user = { user }
          patientId = { params.id }
          approveOrphanPlan = { approveOrphanPlan }
          removeOrphanPlan = { removeOrphanPlan }
        />
        { mode === 'edit' ?
          <TreatmentPlansGroupEdit planGroups = { _.first(partitionedPlans) }
            conditions = { _.filter(chart.conditions, 'id') }
            symptoms = { allSymptoms(chart) }
            ref = 'treatmentPlansGroupEdit'
            searchChart = { searchChart }
            token = { token }
          /> :
          ''
        }
      </div>
    );
  }

	renderChart() {
    var { chart, mode } = this.state;
    var { user, searchChart, token } = this.props;
    var { handleChangeInConditions, renderTreatmentPlans } = this;
    return (
      <div className = 'row'>
        <div className = 'col-md-6'>
          { mode === 'edit' ?
          <BasicEditChartItem basic = { chart.basic }
            ref = 'basicEdit'
          /> :
          <BasicChartItem basic = { chart.basic } /> }
          { mode === 'edit' ?
          <ConditionsEditChartItem conditions = { chart.conditions }
            ref = 'conditionsEdit'
            searchChart = { searchChart }
            token = { token }
            onChange = { handleChangeInConditions }
          /> :
          <ConditionsChartItem conditions = { chart.conditions } /> }
        </div>
        <div className = 'col-md-6'>
          { getChartItemHeading('Treatment Plans') }
          { renderTreatmentPlans() }
          { mode !== 'edit' ? <TherapyChartItem treatmentPlans = { chart.treatment_plans } /> : null }
        </div>
      </div>
    );
	}

  renderApprovalButton() {
    var user = this.props.user;
    var chart = this.state.chart;
    var approved = !_.isNull(chart) ? chart.approved : true;
    if( isPhysician(user) && !approved ) {
      return (
        <button className = 'btn btn-success std-btn'
          onClick = { this.handleOnApproveClick }>
          <Icon icon = { ACCEPT_ICON }/>&nbsp;
          Approve
        </button>
      )
    }
  }

  renderViewModeActions() {
    var patients = this.props.careteams.map((ct) => { return ct.patient; });
    var user = this.props.user
    if( user && ( !isPhysician(user) || _.any(patients, { id: Number(this.props.params.id) })) ){
      return (
        <div className = 'col-sm-3 col-sm-offset-3'>
          <div className = 'vertically-centered chart-edit-wrapper'>
            { this.renderApprovalButton() }&nbsp;
            <button className = 'btn btn-primary std-btn'
              onClick = { this.changeMode('edit') }>
              Update
            </button>
          </div>
          <div className = 'vertically-centered text-right'>
            <h5>
              <ActivitiesLink to = { '/users/' + this.props.params.id + '/chart/activities' }/>
            </h5>
          </div>
        </div>
      )
    }
  }

  renderEditModeActions() {
    return (
      <div className = 'col-sm-6'>
        <div className = 'col-md-3 col-md-offset-3 col-xs-12 margin-top-7 text-right right-padding-0 left-padding-0'>
          { this.renderApprovalButton() }
        </div>
        <div className = 'col-md-3 col-xs-6 margin-top-7 text-right right-padding-0 left-padding-0'>
          <button className = 'btn btn-primary std-btn'
            onClick = { this.changeMode('view') }>
            view
          </button>
        </div>
        <div className = 'col-md-3 col-xs-6 right-padding-0 left-padding-0 margin-top-7 text-right'>
          <button className = 'btn btn-primary std-btn'
            onClick = { this.handleOnUpdateClick }>
            update
          </button>
        </div>
      </div>
    )
  }

  collectBasicChartInfo() {
    return this.refs.basicEdit.getData();
  }

  collectConditionsChartInfo() {
    var conditions = [...this.state.chart.conditions];
    return _.map(conditions, condition => {
      return {
        ...condition,
        diagnosis_date: getTimeInUTC(new Date(Number(condition['diagnosis_date'])))
      };
    });
  }

  collectTreatmentPlansInfo() {
    if(this.refs.treatmentPlansGroupEdit) {
      return this.refs.treatmentPlansGroupEdit.getData();
    }
    return {};
  }

  collectChartInfo() {
    var basic = this.collectBasicChartInfo();
    var conditions = this.collectConditionsChartInfo();
    var treatment_plans = this.collectTreatmentPlansInfo();

    return { basic, conditions, treatment_plans }
  }

  sendChart(chart, beingApproved = false) {
    var props = this.props;
    props.sendChart(props.params.id, chart, beingApproved, props.token, chart => {
      this.setState({
        mode: 'view',
        chart
      })
    })
  }

  handleDeleteAllRequestsWarningClose(message) {
    if (message === 'confirm') {
      this.removeTpdRequests();
    }
    this.setState({
      showDeleteAllRequestsWarning: false
    });
  }

  handleTpDeleteWarningClose(message) {
    var planId = this.state.deletingPlan;
    var deletingPlan = null;
    var showTpDeleteWarning = false;

    if (message === 'confirm') {
      this.props.removeOrphanPlan(planId, this.props.token, deleted => {
        var stateChart = this.state.chart;
        var mode = 'view';
        if (deleted) {
          var chart = {
            ...stateChart,
            treatment_plans: _.reject([...stateChart.treatment_plans], { id: planId })
          }
        }
        this.setState({ mode, chart, deletingPlan, showTpDeleteWarning });
      })
    }
    else {
      this.setState({ deletingPlan, showTpDeleteWarning });
    }
  }

  handleOnApproveClick(event) {
    event.preventDefault();
    var state = this.state;
    if (state.mode === 'view') {
      var chart = state.chart;
      var chart = {
        basic: {
          ...chart.basic,
          birthdate: getTimeInUTC(new Date(Number(chart.basic.birthdate)))
        }
      }
      this.sendChart(chart, true)
    }
    else {
      this.sendChart(this.collectChartInfo(), true);
    }
  }

  handleOnUpdateClick(event) {
    event.preventDefault();
    this.sendChart(this.collectChartInfo());
  }

	render() {
    var { state, handleTpDeleteWarningClose, handleDeleteAllRequestsWarningClose } = this;
    var { showTpDeleteWarning, showDeleteAllRequestsWarning } = state;

		return (
			<div className = 'container'>
        <div className = 'row'>
          <div className = 'col-sm-6'>
            <h5>Patient: { this.state.chart ? this.state.chart.name : null }</h5>
          </div>
          { !(this.state.mode === 'edit') ? this.renderViewModeActions() : this.renderEditModeActions() }
        </div>
        <hr />
        <div className = 'col-sm-12 margin-top-15'>
          { this.state.chart ? this.renderChart() : <PreLoader visible = { true }/> }
        </div>
        <Confirm show  = { showTpDeleteWarning }
          title = 'Delete Orphan Treatment Plan'
          message = 'Are you sure, you want to delete this orphan plan ?'
          onClose = { handleTpDeleteWarningClose }
        />
        <Confirm show = { showDeleteAllRequestsWarning }
          title = 'Delete all pending survey requests'
          message = 'Are you sure, you want to delete all pending requests for all treatment plan dependent surveys sent to this patient'
          onClose = { handleDeleteAllRequestsWarningClose }
        />
      </div>
		)
	}
}

PatientChartView.propTypes = {
  token: PropTypes.object.isRequired,
  user: PropTypes.object.isRequired,
  careteams: PropTypes.array.isRequired
}

const PendingSurveyWarning = ({ onDeleteClick, userPatient }) => (
  <div className = 'alert alert-warning full-width'>
    <p>
      <span>{ userPatient ? 'You have' : 'Patient has' }</span>&nbsp;
      <span>pending survey requests for treatment plan dependent surveys, please resolve them first before making any changes to treatment plans.</span>
    </p>
    <div>
      <button onClick = { onDeleteClick }
        className = 'btn btn-link link-btn no-padding remove-btn font-size-14'>
        Delete pending requests
      </button>
    </div>
  </div>
);
