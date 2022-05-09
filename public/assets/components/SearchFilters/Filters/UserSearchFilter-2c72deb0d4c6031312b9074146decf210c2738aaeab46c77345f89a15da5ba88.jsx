class UserSearchFilter extends Component {

  constructor(props) {
    super(props)
    this.state = {
      selectedValues: []
    }
    this.onChange = this.onChange.bind(this);
  }

  getOptions() {
    return _.map(this.props.members, member => {
      return {
        value: member.id,
        label: member.name
      }
    })
  }

  onChange(values) {
    this.setState({
      selectedValues: _.map(values, 'value')
    })

    if(this.props.onChange) {
      this.props.onChange(values);
    }
  }

  render() {
    return (
      <Select name = 'search-filter-careteam-members'
        options = { this.getOptions() }
        onChange = { this.onChange }
        value = { this.state.selectedValues }
        multi = { true }
        placeholder = { this.props.placeholder || 'Search using users...' }
      />
    )
  }
}

UserSearchFilter.propTypes = {
  members: PropTypes.array.isRequired,
  onChange: PropTypes.func,
  placeholder: PropTypes.string
}
