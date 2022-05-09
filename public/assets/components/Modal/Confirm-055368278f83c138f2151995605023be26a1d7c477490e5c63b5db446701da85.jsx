var Modal = ReactBootstrap.Modal;
var Button = ReactBootstrap.Button;
class Confirm extends Component {

  constructor(props) {
    super(props);
    this.state = {
      show: this.props.show
    }
  }

  close(message, event) {
    event.preventDefault();
    this.setState({ show: false });
    this.props.onClose(message);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      show: nextProps.show
    })
  }

  render() {
    return (
      <Modal show = { this.state.show }
        onHide = { this.close.bind(this, 'cancel') }>
        <Modal.Header closeButton>
          <Modal.Title>
            { this.props.title }
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          { this.props.message }
        </Modal.Body>
        <Modal.Footer>
          <Button onClick = { this.close.bind(this, 'confirm') }
            bsStyle = 'primary'>Confirm</Button>
          <Button onClick = { this.close.bind(this, 'cancel' ) }>Cancel</Button>
        </Modal.Footer>
      </Modal>
    )
  }
}

Confirm.propTypes = {
  show: PropTypes.bool.isRequired,
  message: PropTypes.string.isRequired,
  onClose: PropTypes.func.isRequired,
  title: PropTypes.string
}
