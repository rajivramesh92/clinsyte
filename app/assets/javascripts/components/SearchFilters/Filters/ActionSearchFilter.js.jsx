class ActionSearchFilter extends Component {

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
      { value: 'create', label: 'Additions'},
      { value: 'update', label: 'Updates'},
      { value: 'destroy', label: 'Deletions'}
    ]
  }

  render() {
    return (
      <Select name = 'action-search-filter'
        options = { this.getOptions() }
        onChange = { this.onChange }
        multi = { true }
        value = { this.state.selectedValues }
        searchable = { false }
        placeholder = { this.props.placeholder || 'Search using actions...' }
      />
    )
  }
}

ActionSearchFilter.propTypes = {
  onChange: PropTypes.func,
  placeholder: PropTypes.string
}
