class AutoConfirmSwitch extends Component {

  constructor(props) {
    super(props);
    this.handleAutoConfirmChange = this.handleAutoConfirmChange.bind(this);
  }

  handleAutoConfirmChange(mode) {
    this.props.toggleAutoConfirm(mode, this.props.token)
  }

  render() {
    return (
      <CheckBoxSwitch mode = { this.props.autoConfirm }
        callback = { this.handleAutoConfirmChange }
        className = 'auto-confirm-switch'
      />
    )
  }
}

AutoConfirmSwitch.propTypes = {
  autoConfirm: PropTypes.bool.isRequired
}
