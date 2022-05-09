class ListEditWithItems extends Component {

  constructor(props) {
    super(props);
    this.handleUpdateClick = this.handleUpdateClick.bind(this);
  }

  handleUpdateClick(event) {
    var name = this.refs.listName.getName();
    var optionsAttributes = this.refs.listOptions.getOptions();
    var error = checkListInputErrors({ name, optionsAttributes });
    if (error) {
      showToast(error, 'error');
    }
    else {
      var data = { name, options_attributes: optionsAttributes };
      this.props.onUpdate(data);
    }
  }

  render() {
    return (
      <div>
        <div className = 'row'>
          <div className = 'col-xs-10 col-xs-offset-1 text-center'>
            <label className = 'blue font-size-14'>
              Edit List
            </label>
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-xs-12'>
            <ListNameInput listName = { this.props.list.name }
              ref = 'listName'
            />
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-xs-12'>
            <CreateListOptions ref = 'listOptions'
              options = { this.props.list.options }
            />
          </div>
        </div>
        <div className = 'row'>
          <div className = 'col-xs-12'>
            <button className = 'btn btn-primary std-btn pull-right'
              onClick = { this.handleUpdateClick }>
              Update
            </button>
            <span className = 'pull-right'>
              <button className = 'btn btn-default std-btn'
                onClick = { this.props.onCancel }>
                Cancel
              </button>
              &nbsp;&nbsp;
            </span>
          </div>
        </div>
      </div>
    )
  }
}

ListEditWithItems.propTypes = {
  list: PropTypes.object.isRequired,
  onUpdate: PropTypes.func.isRequired,
  onCancel: PropTypes.func.isRequired
}
