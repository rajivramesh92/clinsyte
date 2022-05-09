/**
 * component to hold the interval options for DayScheduler component
 */

class DaySchedulerOptions extends Component {

  constructor(props) {
    super(props);
    this.state = {
      selectedValue: this.props.defaultValue
    }

    this.handleOnChange = this.handleOnChange.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      selectedValue: nextProps.defaultValue
    })
  }

  handleOnChange(selectedOption) {
    if(this.props.onChange) {
      this.props.onChange(selectedOption.value);
    }
  }

  getOptions() {
    var options = DAY_SCHEDULER_OPTIONS;
    return _.map(options, option => {
      return {
        label: capitalize(option),
        value: option
      }
    })
  }

  render() {
    return (
      <Select name = 'day-scheduler-options'
        options = { this.getOptions() }
        value = { this.state.selectedValue }
        placeholder = 'Choose your schedule...'
        onChange = { this.handleOnChange }
        searchable = { false }
        className = { this.props.className }
        clearable = { false }
      />
    )
  }
}

DaySchedulerOptions.propTypes = {
  defaultValue: PropTypes.string.isRequired,
  onChange: PropTypes.func,
  className: PropTypes.string
}
