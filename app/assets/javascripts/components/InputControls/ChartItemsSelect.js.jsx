class ChartItemsSelect extends Component {

  constructor(props) {
    super(props);
    this.state = {
      selectedItems: []
    }

    this.handleSelectionChange = this.handleSelectionChange.bind(this);
  }

  getChartItems() {
    return this.state.selectedItems
  }

  handleSelectionChange(selectedItems) {
    this.setState({
      selectedItems: _.map(selectedItems, 'value')
    })
  }

  getCharItemsOptions() {
    return _.map(this.props.charItems, item => {
      return {
        value: item.id,
        label: item.name
      }
    })
  }

  render() {
    var itemLabel = this.props.itemLabel;
    return (
      <Select name = { itemLabel + '-select'}
        options = { this.getCharItemsOptions() }
        placeholder = { 'All ' + capitalize(itemLabel) }
        value = { this.state.selectedItems }
        multi = { true }
        onChange = { this.handleSelectionChange }
      />
    )
  }
}

ChartItemsSelect.propTypes = {
  charItems: PropTypes.array,
  itemLabel: PropTypes.string
}
