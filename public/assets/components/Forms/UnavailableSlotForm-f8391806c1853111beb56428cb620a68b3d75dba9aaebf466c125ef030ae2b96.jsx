class UnavailableSlotForm extends Component {

  constructor(props) {
    super(props);
    this.onAddClickHandler = this.onAddClickHandler.bind(this);
  }

  renderTimeSelect(props, defaultTime = 28800) {
    return (
      <TimeSelect className = 'add-slot-time-select form-control'
        defaultTime = { defaultTime }
        difference = { 30 * 60 }
        {...props}
      />
    )
  }

  onAddClickHandler(event) {
    event.preventDefault();
    if(this.props.onAdd) {
      this.props.onAdd({
        date: getFormattedDate(this.refs.date.getDate()),
        from_time: this.refs.fromTime.getTime(),
        to_time: this.refs.toTime.getTime(),
        type: 'unavailable'
      });
    }
  }

  render() {
    var date = new Date();
    var today = { date: date.getDate(), month: date.getMonth()+1, year: date.getFullYear() };

    return (
      <div className = 'row'>
        <div className = 'col-md-12'>
          <div className = 'row new-slot-form'>
            <div className = 'col-md-8 col-md-offset-2'>
              <DateSelect ref = 'date'
                defaultDate = { today }
                start = { today.year }
                end = { today.year + 5 }
                className = "col-md-4 date-select no-padding"
              />
            </div>
          </div>
          <div className = "row margin-top-7">
            <div className = 'col-md-offset-2 col-md-2 no-padding'>
              { this.renderTimeSelect({ end: 86400 - 1800, ref: 'fromTime' }) }
            </div>
            <div className = 'col-md-2 text-center'>
              <label className = 'font-size-18'>to</label>
            </div>
            <div className = 'col-md-2 no-padding'>
              { this.renderTimeSelect({ start: 1800, ref: 'toTime' }, getSecondsForTime(10)) }
            </div>
            <div className = 'col-md-2'>
              <button className = 'btn btn-primary add-slot-add-btn btn-sm margin-top-7'
                onClick = { this.onAddClickHandler }>
                ADD SLOT
              </button>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

UnavailableSlotForm.propTypes = {
  onAdd: PropTypes.func.isRequired
}