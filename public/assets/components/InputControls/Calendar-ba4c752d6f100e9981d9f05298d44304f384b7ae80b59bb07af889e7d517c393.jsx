class Calendar extends Component {

  constructor(props) {
    super(props)
    this.state = {
      slots: this.props.slots,
      selectedSlots: this.props.selectedSlots
    }
  }

  componentDidMount() {
    this.createCalendar()
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      slots: nextProps.slots
    })
  }

  componentDidUpdate() {
    var calendarElement = '#' + this.props.elementId;
    $(calendarElement).fullCalendar('destroy');
    this.createCalendar();
  }

  createCalendar() {
    var calendarElement = $('#' + this.props.elementId);
    calendarElement.fullCalendar({
      header: {
        left: 'prev,next,today',
        center: 'title',
        right: 'month,agendaWeek,agendaDay'
      },
      defaultDate: moment(getTimeInUTC(this.props.defaultDate || new Date())),
      defaultView: ( this.props.defaultDate ? 'agendaDay' : 'month' ),
      events: this.state.slots,
      eventLimit: true,
      timezone: 'UTC',
      eventClick: this.props.onEventClick,
      eventColor: '#2196F3',
      eventRender: (event, element, view) => {
        element.addClass(event._id);
        if( this.state.selectedSlots && this.state.selectedSlots.length && _.any(this.state.selectedSlots, (slotId) => { return element.hasClass(slotId); })){
          element.addClass('busy-slot');
          element.find('.fc-title').text(SLOT_BUSY_MESSAGE);
        }
        else{
          element.attr('title', event.message);
        }

        var isBooked = _.any( event.ranges, (range) => {
          var formatted = moment(new Date(range.start)).utc().toString();
          return ( formatted == event.start.toString() );
        });
        if ( isBooked ){
          return false;
        }

        return (event.ranges.filter( (range) => {
          return ((event.start.isBefore(range.end) &&
            event.end.isAfter(range.start)));
        }).length ) > 0;
      }
    });

    if ( this.props.hiddenSlots && !_.isEmpty(this.props.hiddenSlots) && (this.props.hiddenSlots != this.props.hiddenSlots) ){
      calendarElement.fullCalendar('removeEvents', _.last(this.props.hiddenSlots));
      calendarElement.fullCalendar('refetchEvents');
    }
  }

  render() {
    return <div id = { this.props.elementId }></div>
  }
}

Calendar.propTypes = {
  elementId: PropTypes.string.isRequired,
  slots: PropTypes.array.isRequired,
  onEventClick: PropTypes.func
}
