class AddPhysician extends Component {

  constructor(props) {
    super(props);
    this.state = {}

    this.suggestionSource = this.suggestionSource.bind(this);
    this.onAddPhysician = this.onAddPhysician.bind(this);
    this.onSelect = this.onSelect.bind(this);
    this.keyPressTimeout = 0;
  }

  searchPhysician(query, callback){
    var successCallback = (response) => {
      this.setState({ isSearchInProgress: false });
      callback(response.data.data);
    }.bind(this);

    var errorCallback = (response) => {
      this.setState({ isSearchInProgress: false });
      showToast('Something went wrong!', 'error');
    }.bind(this);

    this.props.onSearch(query, successCallback, errorCallback);
  }

  suggestionSource(query, syncCallback, asyncCallback) {
    var onKeyUp = () => {
      clearTimeout(this.keyPressTimeout);
      this.keyPressTimeout = setTimeout(() => {
        this.setState({ isSearchInProgress: true });
        this.searchPhysician(query, asyncCallback);
      }.bind(this), 1000);
    }.bind(this);

    var onKeyDown = () => {
      clearTimeout(this.keyPressTimeout);
    }.bind(this);

    $('.typeahead').on('keyup', onKeyUp);
    $('.typeahead').on('keydown', onKeyDown);
  }

  onAddPhysician(event) {
    event.preventDefault();
    var selectedPhysician = this.state.selectPhysician;
    if ( selectedPhysician ) {
      this.props.onAddPhysician(selectedPhysician);
    }
    else {
      showToast("Please select physician to proceed", "error")
    }
  }

  suggestionTemplate(user) {
    return React.renderToString(
      <div className='col-md-12 col-xs-12'>
        <b className='col-md-6 col-xs-12 search-result'>
          { user.name }
        </b>
        <div className='col-md-6 col-xs-12 search-result'>
          <div className='col-md-3 col-xs-6'>
            { user.gender }
          </div>
          <div className='col-md-3 col-xs-6'>
            { user.location }
          </div>
        </div>
      </div>
    );
  }

  onSelect(event, suggestion) {
    this.setState({ selectPhysician: suggestion });
  }

  render() {
    return (
      <div className = 'row'>
        <div className = 'col-md-6 col-md-offset-2'>
          <AutoSuggest source = { this.suggestionSource }
            placeholder = { 'Type the name of the physician' }
            suggestionTemplate = { this.suggestionTemplate }
            displayKey = { (user) => { return user.name } }
            onSelectHandler = { this.onSelect }
            isLoading = { this.state.isSearchInProgress }
            name = 'add-physician'
          />
        </div>
        <div className = 'col-md-2'>
          <button className = 'btn btn-primary'
            onClick = { this.onAddPhysician } >
            SELECT
          </button>
        </div>
      </div>
    )
  }
}
