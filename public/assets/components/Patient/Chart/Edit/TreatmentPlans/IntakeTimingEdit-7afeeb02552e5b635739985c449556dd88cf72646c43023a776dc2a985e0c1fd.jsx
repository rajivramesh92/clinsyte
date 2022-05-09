class IntakeTimingEdit extends Component {

  constructor(props) {
    super(props);
    this.state = {
      intakeTiming: props.intakeTiming
    }
    this.handleChangeInIntakeTiming = this.handleChangeInIntakeTiming.bind(this);
  }

  getIntakeTiming() {
    return intakeTimingToTSButtonState[this.refs.intakeTiming.getValue()];
  }

  handleChangeInIntakeTiming(buttonState) {
    this.setState({
      intakeTiming: intakeTimingToTSButtonState[buttonState]
    });
  }

  render() {
    var color = intakeTimingColor[this.state.intakeTiming];
    return (
      <ThreeStateButton onLabel = 'AM'
        offLabel = 'PM'
        noneLabel = 'Generic'
        className = { 'label btn label-' + color + ' btn-' + color }
        defaultValue = { _.invert(intakeTimingToTSButtonState)[this.state.intakeTiming] }
        onChange = { this.handleChangeInIntakeTiming }
        ref = 'intakeTiming'
      />
    );
  }
}

const intakeTimingToTSButtonState = {
  'on': 'am',
  'off': 'pm',
  'none': 'as_required'
}

IntakeTimingEdit.propTypes = {
  intakeTiming: PropTypes.oneOf(['am', 'pm', 'as_required'])
}
