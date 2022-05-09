class SendSurvey extends Component {

  constructor(props) {
    super(props);
    this.state = {
      patients: []
    }
    this.handleOnChange = this.handleOnChange.bind(this);
    this.handleClickOnSend = this.handleClickOnSend.bind(this);
    }

  getPatientOptions() {
    return _.map(this.props.careteams, careteam => {
      var patient = careteam.patient;
      return {
        value: patient.id,
        label: patient.name
      }
    })
  }

  handleOnChange(state) {
    return (values) => {
      this.setState({
        [state]: values
      })
    }
  }

  handleClickOnSend(event) {
    var survey = this.refs.surveys.getSurvey()
    var patientIds = _.pluck(this.state.patients, 'value');

    if(!survey || _.isEmpty(patientIds)) {
      showToast('Please select survey and at least one patient to send survey request', 'error')
    }
    else {
      var token = this.props.token;
      this.props.sendSurveyRequest(token, survey.id, patientIds)
      this.refs.surveys.clear();
      this.setState({
        patients: []
      })
    }
  }

  render() {
    return (
      <div className = 'panel panel-default'>
        <div className = 'panel-body'>
          <div className = 'text-center'>
            <h5>Send Survey</h5>
          </div>
          <div className = 'margin-top-40 row'>
            <div className = 'col-md-6'>
              <span className = 'font-bold small blue'>
                <em>Survey To Send</em>
              </span>
              <SurveysSelect ref = 'surveys'
                surveys = { this.props.surveys }
                token = { this.props.token }
              />
            </div>
            <div className = 'col-md-6'>
              <small className = 'font-bold blue'>
                <em>Survey Recipient(s)...</em>
              </small>
              <Select name = 'patient-select'
                options = { this.getPatientOptions() }
                multi = { true }
                placeholder = 'Select Patient(s)...'
                value = { this.state.patients }
                onChange = { this.handleOnChange('patients') }
              />
            </div>
          </div>
          <div className = 'margin-top-15'>
            <LinkButton to = '/surveys'
              val = 'cancel'
              className = 'btn btn-primary std-btn pull-right margin-left-20'
            />
            <button onClick = { this.handleClickOnSend }
              className = 'btn btn-primary std-btn pull-right'>
              <span className = 'font-size-14'>
                <Icon icon = { SEND_SURVEY_ICON }/>
              </span>
              &nbsp;SEND
            </button>
          </div>
        </div>
      </div>
    )
  }
}

SendSurvey.propTypes = {
  surveys: PropTypes.array.isRequired,
  careteams: PropTypes.array.isRequired,
  sendSurveyRequest: PropTypes.func.isRequired,
  token: PropTypes.object.isRequired
}
