class ListsView extends Component {

  constructor(props) {
    super(props);

    this.state = {
      lists: [],
      isFetching: true
    }

    this.renderList = this.renderList.bind(this);
    this.renderLists = this.renderLists.bind(this);
    this.handleDeleteClick = this.handleDeleteClick.bind(this);
    this.handleEditClick = this.handleEditClick.bind(this);
    this.handleCancelClick = this.handleCancelClick.bind(this);
    this.updateList = this.updateList.bind(this);
  }

  componentDidMount() {
    this.props.getLists(this.props.token, lists => {
      this.setState({
        lists,
        isFetching: false
      });
    });
  }

  changeToEdit(edit, listId) {
    var lists = [...this.state.lists];
    lists[_.findIndex(lists, { id: listId })].edit = edit;
    this.setState({
      lists
    });
  }

  updateList(listId) {
    return (data) => {
      var token = this.props.token;
      this.props.updateList(listId, data, token, newList => {

        var lists = [...this.state.lists];
        lists[_.findIndex(lists, { id: listId })] = {
          ...newList,
          edit: false
        };

        this.setState({
          lists
        });
      });
    }
  }

  handleCancelClick(listId) {
    return (event) => {
      this.changeToEdit(false, listId);
    }
  }

  handleEditClick(listId) {
    return (event) => {
      this.changeToEdit(true, listId)
    }
  }

  handleDeleteClick(listId) {
    return (event) => {
      event.preventDefault();

      var token = this.props.token;
      this.props.deleteList(listId, token, list => {
        var lists = _.reject(this.state.lists, { id: listId });
        this.setState({
          lists
        });
      });
    }
  }

  renderListEdit(list) {
    return (
      <ListEditWithItems onUpdate = { this.updateList(list.id) }
        list = { list }
        onCancel = { this.handleCancelClick(list.id) }
      />
    );
  }

  renderList(list, index) {
    return (
      <div className = 'list-group-item'
       key = { list.id }>
        <div className = 'vertically-top'>
          <span className = 'font-bold'>
            { index + 1}.
          </span>
        </div>
        <div className = 'vertically-top full-width'>
          <div className = 'left-padding-0 col-sm-10 col-xs-9'>
            { list.edit ? this.renderListEdit(list) : <ListViewWithItems list = { list } /> }
          </div>
          <div className = 'right-padding-0 col-sm-2 col-xs-3'>
            <span className = 'red cursor-pointer pull-right'
              onClick = { this.handleDeleteClick(list.id) }>
              <Icon icon = { DELETE_ICON }/>
            </span>
            <span className = 'blue cursor-pointer pull-right'
              onClick = { this.handleEditClick(list.id) }>
              <Icon icon = { EDIT_ICON } />&nbsp;&nbsp;
            </span>
          </div>
        </div>
      </div>
    );
  }

  renderLists() {
    var isFetching = this.state.isFetching;
    if (isFetching) {
      return <PreLoader visible = { true } />;
    }
    else {
      return renderItems(this.state.lists, this.renderList);
    }
  }

  render() {
    return (
      <div className = 'col-sm-8 col-sm-offset-2'>
        <LinkButton className = 'btn btn-primary std-btn pull-right'
          to = '/lists/create'
          val = 'Create'
        />
        <h5 className = 'text-center'>
          Lists
        </h5>
        <div className = 'list-group'>
          { this.renderLists() }
        </div>
      </div>
    )
  }
}

ListsView.propTypes = {
  token: PropTypes.object.isRequired,
  getLists: PropTypes.func.isRequired
}
