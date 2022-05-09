class ChartActivitySearch extends Component {

  constructor(props) {
    super(props);
    this.state = {
      chart_items: [],
      actions: [],
      audited_by: [],
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
    return(
      <div className = 'row'>
        <div className = 'col-sm-2 margin-top-7'>
          <ChartItemSearchFilter placeholder = 'All Chart Items'
            onChange = { this.onChange('chart_items') }
          />
        </div>
        <div className = 'col-sm-2 margin-top-7'>
          <ActionSearchFilter placeholder = 'All Activities'
            onChange = { this.onChange('actions') }
          />
        </div>
        <div className = 'col-sm-4 margin-top-7'>
          <UserSearchFilter placeholder = 'By Anyone'
            members = { this.props.userSearchMembers }
            onChange = { this.onChange('audited_by') }
          />
        </div>
        <div className = 'col-sm-3 margin-top-7'>
          <DaySearchFilter defaultValue = { this.state.from_date }
            onChange = { this.onChange('from_date') }
            placeholder = 'Everything (since begining)'
          />
        </div>
        <div className = 'col-sm-1 margin-top-7'>
          <button className = 'btn btn-primary pull-right'
          onClick = { this.handleOnSearchClick }>
            SEARCH
          </button>
        </div>
      </div>
    )
  }
}

ChartActivitySearch.propTypes = {
  userSearchMembers: PropTypes.array.isRequired,
  onSearchClick: PropTypes.func.isRequired
}
