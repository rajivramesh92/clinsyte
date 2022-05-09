class PhysicianHome extends Component {

  constructor(props) {
    super(props);
    this.headings = [
      { key: 1, value: 'Patient'},
      { key: 2, value: 'Last Appointment'},
      { key: 3, value: 'Genetics Results'},
      { key: 4, value: 'Therapy Recommendations' },
      { key: 5, value: 'Status'}
    ];
    this.state = {
      summaries: []
    }
  }

  componentDidMount() {
    var props = this.props;
    props.getSummary(props.token, summaries => {
      this.setState({
        summaries
      })
    })
  }

  renderCareteams(){
    var summaries = this.state.summaries;
    if( !_.isEmpty(summaries) ){

      var patientData = _.map(summaries, summary => {
        var lastAppointmentDate = (summary.last_appointment ? moment(summary.last_appointment, 'YYYY/MM/DD').format('ll') : 'N/A');
        var geneticsResultsGlyph = <i className = { 'glyphicon ' + (summary.genetics_results ? 'glyphicon-ok' : 'glyphicon-remove') }></i>;
        var therepayCount = <span className = 'badge cl-badge'>{ summary.therapy_count }</span>;

        return {
          key: summary.patient.id,
          cells: [
            { key: 1, value: getPatientChartLink(summary.patient) },
            { key: 2, value: lastAppointmentDate },
            { key: 3, value: geneticsResultsGlyph },
            { key: 4, value: therepayCount },
            { key: 5, value: 'Active' }
          ]
        }
      });

      return (
        <ListView className = 'responsive-table table'
          headings = { this.headings }
          rows = { patientData }
        />
      );
    }
  }

  render() {
    return (
      <div>
        <div className = 'row'>
          <div className = 'col-sm-5'>
            <Greeting user = { this.props.user } />
          </div>
          <div className = 'col-sm-7'>
            { isAdmin(this.props.user) ? <AdminPanelLink/> : '' }
          </div>
          <hr />
        </div>
        <div className = 'row'>
          <div className = 'col-md-12'>
            { this.renderCareteams() }
          </div>
        </div>
      </div>
    );
  }
}
