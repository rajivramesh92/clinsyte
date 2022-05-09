/**
 * component will provide the user with values to schedule any event
 */

class DayScheduler extends Component {

  constructor(props) {
    super(props);

    var days = this.props.defaultDays;

    this.schedulerOptionsDays = _.object(DAY_SCHEDULER_OPTIONS, noOfDays);

    schedulerOption = this.getSchedulerOption(days)

    this.state = {
      days,
      schedulerOption
    }

    this.onScheduleOptionsChange = this.onScheduleOptionsChange.bind(this);
    this.handleDaysChange = this.handleDaysChange.bind(this);
  }

  getSchedule() {
    return {
      days: this.state.days,
      fromDate: this.refs.fromDate.getDate(),
      scheduleTime: this.refs.scheduleTime.getTime()
    }
  }

  getSchedulerOption(days) {
    var schedulerOption = _.findKey(this.schedulerOptionsDays, day => {
      return day == days;
    })

    return schedulerOption || _.last(DAY_SCHEDULER_OPTIONS);
  }

  onScheduleOptionsChange(selectedOption) {
    var schedulerOptionsDays = {
      ...this.schedulerOptionsDays,
      [_.last(DAY_SCHEDULER_OPTIONS)]: this.state.days
    }

    this.setComponentState(schedulerOptionsDays[selectedOption], selectedOption)
  }

  handleDaysChange(event) {
    var days = Number(event.currentTarget.value);
    if(!_.isNaN(days)) {
      var schedulerOption = this.getSchedulerOption(days);
      this.setComponentState(days, schedulerOption);
    }
  }

  setComponentState(days, schedulerOption) {
    this.setState({
      days,
      schedulerOption
    })
  }

  render() {
    today = new Date();
    var defaultDate = {
      date: today.getDate(),
      month: today.getMonth() + 1,
      year: today.getFullYear()
    }
    return (
      <div className = { this.props.wrapperClass }>
        <div className = 'row'>
          <div className = 'col-sm-6'>
            <DaySchedulerOptions defaultValue = { this.state.schedulerOption }
              onChange = { this.onScheduleOptionsChange }
            />
          </div>
          <div className = 'col-sm-6'>
            <div className = 'input-group'>
              <input type = 'text'
                className = 'form-control'
                value = { this.state.days }
                onChange = { this.handleDaysChange }
                ref = 'days'
              />
              <span className = 'font-bold font-size-14 input-group-addon'>Days</span>
            </div>
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-sm-6 margin-top-15'>
            <div className = 'font-bold font-size-14 full-width'>
              Start Date:
            </div>
            <DateSelect className = 'col-md-4 date-select-scheduler no-padding'
              start = { defaultDate.year }
              end = { defaultDate.year }
              defaultDate = { defaultDate }
              ref = 'fromDate'
            />
          </div>
          <div className = 'col-sm-6 margin-top-15'>
            <div className = 'font-bold font-size-14 full-width'>
              Schedule Time:
            </div>
            <TimeInput ref = 'scheduleTime'
              { ...timeInputClasses } />
          </div>
        </div>
      </div>
    )
  }
}

DayScheduler.propTypes = {
  defaultDays: PropTypes.number.isRequired,
  wrapperClass: PropTypes.string
}

var noOfDays = [1, 7, 30];

var hoursClass = minutesClass = secondsClass = meridianClass = 'time-input-scheduler-class';
var timeInputClasses = { hoursClass, minutesClass, secondsClass, meridianClass };
