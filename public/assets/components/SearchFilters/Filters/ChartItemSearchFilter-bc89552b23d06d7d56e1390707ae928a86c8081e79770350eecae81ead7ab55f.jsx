class ChartItemSearchFilter extends Component {

  constructor(props) {
    super(props);
    this.state = {
      selectedValues: []
    }
    this.onChange = this.onChange.bind(this);
  }

  onChange(values) {
    this.setState({
      selectedValues: values
    })
    if(this.props.onChange) {
      this.props.onChange(values)
    }
  }

  getOptions() {
   return [
      { value: 'condition', label: 'Conditions' },
      { value: 'symptom', label: 'Symptoms' },
      { value: 'medication', label: 'Medications' },
      { value: 'therapy', label: 'Therapies' },
      { value: 'basic info', label: 'Basics' }
    ];
  }

  render() {
    return (
      <Select name = 'search-filter-chart-item'
        placeholder = { this.props.placeholder || 'Search using chart items...' }
        options = { this.getOptions() }
        multi = { true }
        value = { this.state.selectedValues }
        onChange = { this.onChange }
        searchable = { false }
      />
    )
  }
}

ChartItemSearchFilter.propTypes = {
  onChange: PropTypes.func,
  placeholder: PropTypes.string
}
