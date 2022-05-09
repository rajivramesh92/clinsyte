class ListView extends Component {

  constructor(props) {
    super(props);
  }

  getRowMarkup(row) {
    if(row) {
      return <ListItem cellValues = { row.cells } key = { row.key }/>
    }
  }

  renderRows() {
    return renderItems(this.props.rows, this.getRowMarkup);
  }

  renderHeadings() {
    return renderItems(this.props.headings, this.getHeadingMarkup);
  }

  getHeadingMarkup(heading) {
    if(heading) {
      return <th key = { heading.key } >{ heading.value }</th>
    }
  }

  render() {
    return (
        <table className = { this.props.className }>
          <thead>
            <tr>
              { this.renderHeadings() }
            </tr>
          </thead>
          <tbody>
            { this.renderRows() }
          </tbody>
        </table>
      );
  }
}
