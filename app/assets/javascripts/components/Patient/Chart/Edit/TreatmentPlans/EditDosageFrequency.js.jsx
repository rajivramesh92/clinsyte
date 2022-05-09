var DOSAGE_FREQUENCY_TYPES = ['n times a day', 'no more than n times a day', 'as needed', 'every n hours'];
var combinations = {
  0: [2, 3],
  1: [2, 3],
  2: [0, 1, 3],
  3: [0, 1, 2]
}

class EditDosageFrequency extends Component {

  constructor(props) {
    super(props);

    var types = DOSAGE_FREQUENCY_TYPES;

    var selected = _.map(props.frequencies, 'name')
    var unselected = _.difference(types,selected);
    var frequencies = _.extend(_.object(unselected, createObjects(unselected.length)),_.object(selected, createObjects(selected.length, { selected: true })));
    var enabledFrequencies = this.setEnabledFrequencies(frequencies);
    this.state = {
      frequencies: enabledFrequencies
    }

    this.renderFrequencyOptions = this.renderFrequencyOptions.bind(this);
    this.renderFrequencyOption = this.renderFrequencyOption.bind(this);
    this.handleChangeFrequencyState = this.handleChangeFrequencyState.bind(this);
  }

  setFrequencyState(frequencies) {
    this.setState({
      frequencies
    })
  }

  setEnabledFrequencies(frequencies) {
    var types = DOSAGE_FREQUENCY_TYPES;
    var selected = true;

    var selectedFrequencies = filterObject(frequencies, { selected });

    var selectedFreqComb = _.map(_.keys(selectedFrequencies), frequency => {
      return combinations[_.indexOf(types, frequency)]
    });

    if(_.isEmpty(selectedFrequencies)) {
      enabledFrequencies = types;
    }
    else {
      enabledFrequencies = _.map(_.intersection.apply(this, selectedFreqComb), index => {
        return types[index];
      })
      .concat(_.keys(selectedFrequencies));
    }

    var frequencies = _.mapObject(frequencies, (frequency, key) => {
      return {
        ...frequency,
        disabled: !_.contains([...enabledFrequencies], key)
      }
    });

    return frequencies;
  }

  handleChangeFrequencyState(option, index) {

    return (event) => {
      var checked = event.currentTarget.checked;
      var frequencies = {
        ...this.state.frequencies,
        [option]: {
          selected: checked,
          _destroy: !checked
        }
      };

      this.setFrequencyState(this.setEnabledFrequencies(frequencies))
    }
  }

  getFrequencyFromProps(name) {
    return _.findWhere(this.props.frequencies, { name }) || _.create();
  }

  getData() {
    var frequencies = this.state.frequencies;

    var dosageFrequency = _.map(frequencies, (frequencyValue, name) => {

      let id = this.getFrequencyFromProps(name).id;
      if( id || frequencies[name].selected ) {
        return {
          id,
          name,
          _destroy: frequencies[name]._destroy,
          value: (this.refs[name] ? this.refs[name].value : null)
        };
      }
      return;

    });

    return _.compact(dosageFrequency);
  }

  renderFrequencyOption(option, index) {
    var frequency = this.state.frequencies[option]

    var getOptionText = () => {
      if(option !== 'as needed') {
        return (
          <div className = { frequency.selected ? 'row' : 'hidden' }>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <span className = 'col-xs-6'>
              Enter value for `N`
            </span>
            <span className = 'col-xs-6'>
              <input type = 'text'
                className = 'form-control'
                ref = { option }
                defaultValue = { this.getFrequencyFromProps(option).value }
              />
            </span>
          </div>
        )
      }
    }
    var frequency = this.state.frequencies[option];
    return (
      <div key = { option }>
        <div className = 'checkbox'>
          <label className = 'font-size-14'>
            <input type = 'checkbox'
            disabled = { Boolean(frequency.disabled) }
            checked = { Boolean(frequency.selected) }
            onChange = { this.handleChangeFrequencyState(option, index) }
          />&nbsp;
          <span className = { frequency.disabled ? 'strike text-muted' : '' }>
            { capitalize(option.replace(/\bn\b/, '`N`')) }
          </span>
          </label>
        </div>
        { getOptionText() }
      </div>
    )
  }

  renderFrequencyOptions() {
    return renderItems(DOSAGE_FREQUENCY_TYPES, this.renderFrequencyOption)
  }

  render() {
    return (
      <div>
        <p className = 'font-size-18 font-bold'>Time/Frequency</p>
        <form>
          { this.renderFrequencyOptions() }
        </form>
      </div>
    )
  }
}

EditDosageFrequency.propTypes = {
  frequencies: PropTypes.array
}
