class ListBasedResponse extends Component {

  constructor(props) {
    super(props);

    this.state = {
      selectedItems: []
    }

    this.handleItemChange = this.handleItemChange.bind(this);
  }

  getResponse() {
    var selected = this.state.selectedItems;
    return _.isArray(selected) ? _.pluck(selected, 'value') : [selected.value];
  }

  getSelectOptions() {
    return _.map(this.props.list.options, item => {
      return {
        value: item.id,
        label: item.option
      };
    });
  }

  handleItemChange(selectedItems) {
    this.setState({
      selectedItems
    });
  }

  render() {
    return (
      <Select name = { this.props.name }
        options = { this.getSelectOptions() }
        multi = { this.props.category === MULTI_SELECT }
        placeholder = 'Choose your reponses'
        value = { this.state.selectedItems }
        onChange = { this.handleItemChange }
      />
    );
  }
}

ListBasedResponse.propTypes = {
  name: PropTypes.string.isRequired,
  list: PropTypes.string.isRequired
}
