class StateSearchFilter extends Component {

  constructor(props) {
    super(props);
    this.state = {
      selectedValues: []
    }
    this.handleOnChange = this.handleOnChange.bind(this);
  }

  handleOnChange(selectedValues) {
    this.setState({ selectedValues });
    var onChange = this.props.onChange;

    if(onChange) {
      onChange(selectedValues);
    }
  }

  render() {
    return (
      <Select name = 'state-search-filter'
        options = { getOptions() }
        onChange= { this.handleOnChange }
        multi = { true }
        value = { this.state.selectedValues }
        searchable = { false }
        placeholder = { 'Search using request status...' }
      />
    )
  }
}

StateSearchFilter.propTypes = {
  onChange: PropTypes.func
}

const STATE_OPTIONS = ['submitted', 'started', 'pending'];

var getOptions = () => {
  return _.map(STATE_OPTIONS, option => {
    let value = label = capitalize(option);
    return { value, label };
  });
}
