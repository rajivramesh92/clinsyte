class CreateList extends Component {

  constructor(props) {
    super(props);

    this.state = {
      listItems: []
    }

    this.handleOnCreateClick = this.handleOnCreateClick.bind(this);
  }

  handleOnCreateClick(event) {
    var name = this.refs.listName.getName();
    var optionsAttributes = this.refs.listOptions.getOptions();
    var token = this.props.token;

    var error = checkListInputErrors({ name, optionsAttributes });
    if(error) {
      showToast(error, 'error');
    }
    else {
      this.props.createList({ name, options_attributes : optionsAttributes }, token);
    }
  }

  render() {
    return (
      <div className = 'col-md-8 col-md-offset-2'>
        <div className = 'panel panel-primary'>
          <div className = 'panel-body'>
            <h5 className = 'text-center'>
              New List
              <Note header = 'Empty Options'
                message = 'Empty options will not be stored'
                className = 'pull-right'
              />
            </h5>
            <div className = 'margin-top-40'>
              <ListNameInput ref = 'listName'/>
            </div>
            <div className = 'margin-top-40'>
              <CreateListOptions ref = 'listOptions'/>
            </div>
            <div className = 'margin-top-15'>
              <button className = 'btn btn-primary std-btn pull-right'
                onClick = { this.handleOnCreateClick }>
                Create
              </button>
            </div>
          </div>
        </div>
      </div>
    )
  }
}
