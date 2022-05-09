class RangeBasedOptions extends Component {

  constructor(props) {
    super(props);

    this.state = {
      max: DEFAULT_RANGE_MAX,
      min: DEFAULT_RANGE_MIN
    }

    this.handleChange = this.handleChange.bind(this);
  }

  getAttributes() {
    var max = String(this.state.max);
    var min = String(this.state.min);
    return { max, min }
  }

  validateValues() {
    var max = Number(this.refs.rangeInputmax.value);
    var min = Number(this.refs.rangeInputmin.value);

    if(max > min) {
      return true;
    }
    return false;
  }

  handleChange(type) {
    return (event) => {
      event.preventDefault();

      if(this.validateValues()) {
        rangeInput = Number(this.refs['rangeInput' + type].value);

        if (!_.isNaN(rangeInput)) {
          this.setState({
            [type]: rangeInput
          })
        }
      }
    }
  }

  renderValueInput(type) {
    var rangeInput = this.state[type];
    return (
      <div>
        <label className = 'blue'>
          { capitalize(type) + ' Value' }:&nbsp;&nbsp;
        </label>
        <input type = 'text'
          onChange = { this.handleChange(type) }
          value = { rangeInput }
          className = 'range-question-input'
          ref = { 'rangeInput' + type }
        />
      </div>
    )
  }

  render() {
    return (
      <div className = 'row'>
        <div className = 'col-sm-6'>
          { this.renderValueInput('min') }
        </div>
        <div className = 'col-sm-6'>
          { this.renderValueInput('max') }
        </div>
      </div>
    )
  }
}
