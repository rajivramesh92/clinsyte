class SentRequestSearch extends Component {

  constructor(props) {
    super(props);
    this.state = {
      state: [],
      receiverId: []
    }
    this.handleChange = this.handleChange.bind(this);
    this.handleOnSearchClick = this.handleOnSearchClick.bind(this);
  }

  handleChange(searchFilter) {
    return (filterParams) => {
      this.setState({
        [searchFilter]: _.pluck(filterParams, 'value')
      });
    }
  }

  handleOnSearchClick(event) {
    event.preventDefault();
    this.props.onSearchClick(this.state);
  }

  render() {
    return (
      <div className = 'row'>
        <div className = 'col-sm-5 margin-top-7'>
          <StateSearchFilter onChange = { this.handleChange('state') }/>
        </div>
        <div className = 'col-sm-5 margin-top-7'>
          <UserSearchFilter placeholder = { this.props.memberSelectPlaceholder }
            members = { this.props.members }
            onChange = { this.handleChange('receiverId') }
          />
        </div>
        <div className = 'col-sm-2 margin-top-7'>
          <button className = 'btn btn-primary pull-right'
            onClick = { this.handleOnSearchClick }>
            Search
          </button>
        </div>
      </div>
    )
  }
}

SentRequestSearch.propTypes = {
  members: PropTypes.array.isRequired,
  onSearchClick: PropTypes.func.isRequired,
  memberSelectPlaceholder: PropTypes.string.isRequired
}
