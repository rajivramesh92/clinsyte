class SlotManagerView extends Component {

  constructor(props) {
    super(props);
    this.getDoneButton = this.getDoneButton.bind(this);
  }

  getDoneButton(){
    return (
      <div className = 'text-center margin-top-40'>
        <Link className = 'btn btn-success'
          to = '/home'>
          <Icon icon = { WORK_COMPLETE_ICON }/>&nbsp;
          Done
        </Link>
        <div>
          <small>
            <i>
              ( Do not click on this button unless you are done add/editing the slots )
            </i>
          </small>
        </div>
      </div>
    );
  }

  render() {
    return (
      <div className = 'row'>
        <div className = 'col-sm-6 col-sm-offset-3'>
          <h5 className = 'text-center'>
            Availability Slots For Appointments
          </h5>
          <div className = 'margin-top-15'>
            <SlotForm onAdd = { this.props.onAddSlot } />
          </div>
          <div className = 'row margin-top-40'>
            <div className = 'col-sm-6 col-sm-offset-3'>
              { this.props.children }
            </div>
          </div>

          <div className = 'margin-top-40'>
            <h5 className = 'text-center'>
              Availability Slots Allocated For Appointments
            </h5>
          </div>
          <div className = 'margin-top-15'>
            <SlotCollection slots = { this.props.timeSlots }
              onRemove = { this.props.onRemoveSlot }
            />
          </div>

          <div className = 'margin-top-40'></div>
          <div className = 'row'>
            <div className = 'col-md-12 col-xs-12'>
              <h5 className = 'text-center'>Unavailable Slots</h5>
            </div>
          </div>
          <UnavailableSlotForm onAdd = { this.props.onAddSlot } />
          <div className = 'margin-top-40'></div>
          <UnavailableSlotCollection slots = { this.props.unavailableSlots }
            onRemove = { this.props.onRemoveSlot }
          />
          { this.props.showDone ? this.getDoneButton() : '' }
        </div>
      </div>
    )
  }
}

SlotManagerView.propTypes = {
  showDone: PropTypes.bool  //prop to decide whether to show done button or not
}
