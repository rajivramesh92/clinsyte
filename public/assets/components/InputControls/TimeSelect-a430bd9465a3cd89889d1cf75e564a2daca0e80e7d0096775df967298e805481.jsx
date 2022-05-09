class TimeSelect extends Component {

  constructor(props) {
    super(props);
    this.onTimeChangeHandler = this.onTimeChangeHandler.bind(this);
    this.difference = this.props.difference || 3600;
    this.start = this.props.start || 0;
    this.end = this.props.end || 86400;
  }

  getTime() {
    return this.refs.time.getValue();
  }

  onTimeChangeHandler(time) {
    if(this.props.onChange) {
      this.pops.onChange(time);
    }
  }

  componentWillMount() {
    var seconds = _.range(this.start, this.end, this.difference);
    this.options = _.map(seconds, s => {
      return {
        value: s,
        display: getHoursIn12HourMode(s),
        key: s
      }
    })
  }

  render() {
    return (
      <DropDown defaultVal = { this.props.defaultTime || this.start }
        options = { this.options }
        ref = 'time'
        className = { this.props.className }
        onChange = { this.onTimeChangeHandler }
      />
    )
  }
}

TimeSelect.propTypes = {
  className: PropTypes.string,
  onChange: PropTypes.func,
  difference: PropTypes.number,
  start: PropTypes.number,
  end: PropTypes.number,
  defaultTime: PropTypes.number
}
