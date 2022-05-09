class MedicineAlert extends Component {

  constructor(props) {
    super(props);
    this.state = {
      show: props.show,
      message: props.message
    }

    this.handleTakeDosageClick = this.handleTakeDosageClick.bind(this);
    this.handleSnoozeClick = this.handleSnoozeClick.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      show: nextProps.show,
      message: nextProps.message
    })
  }

  handleSnoozeClick(event) {
    event.preventDefault();
    var props = this.props;
    props.snoozeAlert(props.planId, props.therapyId, props.token)
  }

  handleTakeDosageClick(event) {
    event.preventDefault();
    var props = this.props;
    props.takeDosage(props.planId, props.therapyId, props.token);
  }

  render() {
    return (
      <Modal show = { this.state.show }
        onHide = { this.props.closeReminder }
        container = { this }>
        <Modal.Header closeButton>
          <Modal.Title>
            Medicine Alert
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <p className = 'font-bold'>
            { this.props.message }
          </p>
        </Modal.Body>
        <Modal.Footer>
          <button className = 'btn btn-success btn-sm'
            onClick =  { this.handleTakeDosageClick } >
            I am taking dose now
          </button>
          <button className = 'btn btn-danger btn-sm'
            onClick = { this.handleSnoozeClick }>
            Snooze this remdinder
          </button>
        </Modal.Footer>
      </Modal>
    )
  }

}

MedicineAlert.propTypes = {
  show: PropTypes.bool.isRequired,
  message: PropTypes.string,
  planId: PropTypes.string
}
