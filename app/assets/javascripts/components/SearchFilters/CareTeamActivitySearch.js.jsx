class CareTeamActivitySearch extends Component {

  constructor(props) {
    super(props);
    this.state = {
      actions: [],
      from_date: 'in last 30 days'
    }
    this.onChange = this.onChange.bind(this);
    this.handleOnSearchClick = this.handleOnSearchClick.bind(this);
  }

  onChange(searchFilter) {
    return (filterParams) => {
      this.setState({
        [searchFilter]: searchFilter === 'from_date' ? filterParams.value : _.map(filterParams, 'value')
      })
    }
  }

  handleOnSearchClick(event) {
    event.preventDefault();
    this.props.onSearchClick(this.state)
  }

  render() {
    return (
      <div className = 'row'>
        <div className = 'col-sm-5 margin-top-7'>
          <ActionSearchFilter placeholder = 'All actions (addition, updation, deletion)'
            onChange = { this.onChange('actions') }
          />
        </div>
        <div className = 'col-sm-5 margin-top-7'>
          <DaySearchFilter placeholder = 'Everything (since begining)'
            onChange = { this.onChange('from_date') }
            defaultValue = { this.state.from_date }
          />
        </div>
        <div className = 'col-sm-2 margin-top-7'>
          <button className = 'btn btn-primary pull-right'
          onClick = { this.handleOnSearchClick }>
            SEARCH
          </button>
        </div>
      </div>
    )
  }
}

CareTeamActivitySearch.propTypes = {
  onSearchClick: PropTypes.func.isRequired
}
