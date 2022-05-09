class ListItem extends Component {

  getCellMarkup(cell) {
    if(cell) {
      return <td key = { cell.key }> { cell.value } </td>
    }
  }

  renderCells() {
    return renderItems(this.props.cellValues, this.getCellMarkup);
  }

  render() {
    return (
        <tr>
          { this.renderCells() }
        </tr>
      )
  }
}
