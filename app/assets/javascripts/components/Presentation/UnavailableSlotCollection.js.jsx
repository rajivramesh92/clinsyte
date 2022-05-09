class UnavailableSlotCollection extends Component {

  constructor(props) {
    super(props)
    this.renderTimeSlot = this.renderTimeSlot.bind(this);
    this.renderTimeRows = this.renderTimeRows.bind(this);
  }

  renderTimeRows(slot) {
    return (
      <tr key = { slot.id }>
        <td className = 'vertically-centered'>
          { getHoursIn12HourMode(Number(slot.from_time)) }
        </td>
        <td className = 'vertically-centered'>
          { getHoursIn12HourMode(Number(slot.to_time)) }
        </td>
        <td className = 'vertically-centered'>
          <button className = 'btn btn-danger btn-sm'
            onClick = { this.onRemoveClickHandler.bind(this, slot.id) }>
            REMOVE
          </button>
        </td>
      </tr>
    )
  }

  renderTimeSlot(slots, date) {
    return (
      <tbody key = { date }
        className = 'slot-collections-tbody'>
        <tr>
          <td className = 'vertically-centered'
            rowSpan = { slots.length }>
            <strong>
              { new Date(date).toDateString() }
            </strong>
          </td>
          <td className = 'vertically-centered'>
          { getHoursIn12HourMode(Number(slots[0].from_time)) }
          </td>
          <td className = 'vertically-centered'>
            { getHoursIn12HourMode(Number(slots[0].to_time)) }
          </td>
          <td className = 'vertically-centered'>
            <button className = 'btn btn-danger btn-sm'
              onClick = { this.onRemoveClickHandler.bind(this, slots[0].id) }>
              REMOVE
            </button>
          </td>
        </tr>
          { renderItems(_.rest(slots), this.renderTimeRows) }
      </tbody>
    )
  }

  onRemoveClickHandler(slotId, event) {
    event.preventDefault();
    this.props.onRemove(slotId);
  }

  renderTimeSlots() {
    if ( _.isEmpty(this.props.slots) ){
      return (
        <tbody>
          <tr>
            <td colSpan = '4'>
              <i className = 'text-muted'>
                No unavailable slots added!
              </i>
            </td>
          </tr>
        </tbody>
      );
    }
    else{
      return renderItems(_.groupBy(this.props.slots, 'date'), this.renderTimeSlot)
    };
  }

  render() {
    return (
      <table className = 'table table-borderless table-hover text-center'>
        <thead>
          <tr>
            <th className = 'text-center'>Date</th>
            <th className = 'text-center'>Start time</th>
            <th className = 'text-center'>End time</th>
            <th className = 'text-center'>Action</th>
          </tr>
        </thead>
        { this.renderTimeSlots() }
      </table>
    )
  }
}

UnavailableSlotCollection.propTypes = {
  slots: PropTypes.array.isRequired,
  onRemove: PropTypes.func.isRequired
}