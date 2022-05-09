class ThreeStateButton extends Component {

  constructor(props) {
    super(props);
    this.state = {
      buttonState: this.props.defaultValue || TSB_NONE
    }
    this.handleClick = this.handleClick.bind(this);
  }

  getValue() {
    return this.state.buttonState;
  }

  getButtonValue() {
    var buttonStateValueMap = {
      [TSB_ON]: this.props.onLabel || 'On',
      [TSB_OFF]: this.props.offLabel || 'Off',
      [TSB_NONE]: this.props.noneLabel || 'none'
    };

    return buttonStateValueMap[this.state.buttonState];
  }

  handleClick(event) {
    event.preventDefault();
    var buttonState = getNext(TSB_STATES, this.state.buttonState);
    this.setState({ buttonState });
    if (this.props.onChange) {
      this.props.onChange(buttonState);
    }
  }

  render() {
    return (
      <button onClick = { this.handleClick }
        className = { this.props.className }>
        { this.getButtonValue() }
      </button>
    );
  }

}

ThreeStateButton.propTypes = {
  defaultValue: PropTypes.oneOf(TSB_STATES),
  onChange: PropTypes.func,
  className: PropTypes.string,
  onLabel: PropTypes.string,
  offLabel: PropTypes.string,
  noneLabel: PropTypes.string
}

const TSB_ON = 'on';
const TSB_OFF = 'off';
const TSB_NONE = 'none';
const TSB_STATES = [TSB_ON, TSB_OFF, TSB_NONE];
