class ListBasedOptions extends Component {

  getAttributes() {
    return {
      list_id: this.refs.listSelect.getValue(),
      category: this.refs.multipleResponse.checked ? MULTI_SELECT : SINGLE_SELECT
    }
  }

  getListOptions() {
    var lists = this.props.lists;
    var defaultOption = {
      value: null,
      key: 0,
      display: 'No List Selected'
    };

    return _.union([defaultOption], _.map(lists, list => {
      return {
        display: list.name,
        key: list.id,
        value: list.id
      }
    }));
  }


  render() {
    return (
      <div>
        <label className = 'blue'>
          Select List
        </label>
        <div className = 'checkbox pull-right no-margin'>
          <input ref = 'multipleResponse'
            type = 'checkbox'
          />
          Multiple reponses
        </div>
        <DropDown ref = 'listSelect'
          options = { this.getListOptions() }
          className = 'form-control'
        />
      </div>
    );
  }
}


ListBasedOptions.propTypes = {
  lists: PropTypes.array.isRequired
}
