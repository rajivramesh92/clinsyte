class DaySelect extends Component {

  constructor(props) {
    super(props);
    this.onChangeHandler = this.onChangeHandler.bind(this);
  }

  getDayOptions() {
    return _.map(days, day => {
      return {
        display: capitalize(day),
        key: day,
        value: day.toLowerCase()
      }
    })
  }

  getDay() {
    return this.refs.day.getValue()
  }

  onChangeHandler(day) {
    if(this.props.onChange) {
      this.props.onChange(day)
    }
  }

  render() {
    return (
      <DropDown className = { this.props.className }
        options = { this.getDayOptions() }
        ref = 'day'
        defaultVal = { this.props.defaultDay || 'monday'}
        onChange = { this.onChangeHandler }
      />
    )
  }
}

DaySelect.propTypes = {
  className: PropTypes.string,
  defaultDay: PropTypes.string,
  onChange: PropTypes.func
}
