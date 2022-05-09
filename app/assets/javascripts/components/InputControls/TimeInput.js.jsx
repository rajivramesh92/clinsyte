class TimeInput extends Component {

  getTime() {
    var meridian = this.refs.meridian.getValue();
    var hours = Number(this.refs.hours.getValue()) + (meridian === 'PM' ? 12 : 0);
    var minutes = Number(this.refs.minutes.getValue());
    var seconds = Number(this.refs.seconds.getValue());
    return new Date(0, 0, 0, hours, minutes, seconds);
  }

  render() {
    var { time, hoursClass, minutesClass, secondsClass, meridianClass, showSeconds } = this.props;
    return (
      <div>
        <DropDown ref = 'hours'
          options = { getNumberOptions(12) }
          className = { hoursClass }
          defaultVal = { time.getHours() % 12 }
        />
        { delimitor }
        <DropDown ref = 'minutes'
          options = { getNumberOptions(60) }
          className = { minutesClass }
          defaultVal = { time.getMinutes() }
        />
        { delimitor }
        <DropDown ref = 'seconds'
          options = { getNumberOptions(60) }
          className = { secondsClass + (!showSeconds ? ' hidden' : '') }
          defaultVal = { time.getSeconds() }
        />
        { showSeconds ? delimitor : '' }
        <DropDown ref = 'meridian'
          options = { getMeridianOptions() }
          className = { meridianClass }
          defaultVal = { getMeridianFromHour(time.getHours()) }
        />
      </div>
    );
  }
}

TimeInput.propTypes = {
  onChange: PropTypes.func,
  hoursClass: PropTypes.string,
  meridianClass: PropTypes.string,
  minutesClass: PropTypes.string,
  secondsClass: PropTypes.string,
  showSeconds: PropTypes.bool,
  time: (props, propName) => {
    if (!props[propName] instanceof Date) {
      return new Error('Time prop accepts only value of type Date');
    }
  }
}

TimeInput.defaultProps = {
  time: new Date(0, 0, 0, 0, 0, 0)
}

const getMeridianOptions = () => {
  return _.map(['AM', 'PM'], meridian => {
    let display = value = key = meridian;
    return { value, key, display };
  });
}

const getNumberOptions = num => {
  return _.map(_.range(num), n => {
    let display = key = padLeft(n, '0', 2);
    return { display, value: n, key };
  });
}

const getMeridianFromHour = hour => (hour % 24) > 11 ? 'PM' : 'AM';

const delimitor = <span> : </span>;
