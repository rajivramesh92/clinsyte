class EditDosage extends Component {

  constructor(props) {
    super(props);
    this.state = {
      dosage: props.dosage || { quantity: 0, unit: _.first(DOSAGE_UNITS) }
    }
    this.handleOnChangeInQuantity = this.handleOnChangeInQuantity.bind(this);
    this.handleOnChangeInUnit = this.handleOnChangeInUnit.bind(this);
  }

  getData() {
    return this.state.dosage
  }

  handleOnChangeInQuantity(event) {
    var quantity = event.currentTarget.value;
    if(!_.isNaN(Number(quantity)) && Number(quantity) >= 0) {
      this.setState({
        dosage: {
          ...this.state.dosage,
          quantity
        }
      })
    }
  }

  handleOnChangeInUnit(unit) {
    this.setState({
      dosage: {
        ...this.state.dosage,
        unit
      }
    })
  }

  getUnitOptions() {
    return _.map(DOSAGE_UNITS, unit => {
      return {
        value: unit,
        display: unit,
        key: unit
      }
    })
  }

  render() {
    return (
      <div>
        <p className = 'font-size-18 font-bold'>Dosage</p>
        <div className = { 'display-table-row form-control' }>
          <div className = 'display-table-cell'>
            <small className = 'font-bold'>
              Quantity
            </small>
            <input type = 'text'
              className = 'form-control'
              ref = 'quants'
              value = { this.state.dosage.quantity }
              onChange = { this.handleOnChangeInQuantity }
            />
          </div>
          <div className = 'display-table-cell'>
            <small className = 'font-bold'>
              Unit
            </small>
            <DropDown className = 'form-control'
              options = { this.getUnitOptions() }
              defaultVal = { this.state.dosage.unit }
              ref = 'unit'
              onChange = { this.handleOnChangeInUnit }
            />
          </div>
        </div>
      </div>
    )
  }
}

EditDosage.propTypes = {
  dosage: PropTypes.shape({
    quantity: PropTypes.number.isRequired,
    unit: PropTypes.string.isRequired
  })
}
