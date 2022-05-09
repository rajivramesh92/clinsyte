class SlotForm extends Component {

  constructor(props) {
    super(props);
    this.onAddClickHandler = this.onAddClickHandler.bind(this);
  }

  renderTimeSelect(props, defaultTime) {
    return (
      <TimeSelect className = 'form-control'
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
        day: this.refs.day.getDay(),
        from_time: this.refs.fromTime.getTime(),
        to_time: this.refs.toTime.getTime(),
        type: 'available'
      })
    }
  }

  render() {
    return (
      <div className = 'row'>
          <div className = 'col-md-3 margin-top-7'>
            <DaySelect defaultDay = 'monday'
              ref = 'day'
              className = 'form-control'
            />
          </div>
          <div className = 'col-md-3 margin-top-7'>
            { this.renderTimeSelect({ end: 86400 - 1800, ref: 'fromTime' }, getSecondsForTime(8)) }
          </div>
          <div className = 'col-md-1 text-center margin-top-7'>
            <label className = 'font-size-18'>
              to
            </label>
          </div>
          <div className = 'col-md-3 margin-top-7'>
            { this.renderTimeSelect({ start: 1800, ref: 'toTime' }, getSecondsForTime(10)) }
          </div>
          <div className = 'col-md-2 margin-top-15'>
            <button className = 'btn btn-primary pull-right btn-sm'
              onClick = { this.onAddClickHandler }>
              ADD SLOT
            </button>
          </div>
      </div>
    )
  }
}

SlotForm.propTypes = {
  onAdd: PropTypes.func.isRequired
}
