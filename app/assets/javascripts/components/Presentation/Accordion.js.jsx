class Accordion extends Component {

  constructor(props) {
    super(props);
    this.renderInPanel = this.renderInPanel.bind(this);
  }

  renderInPanel(item) {
    return (
      <CollapsingPanel title = { item.props.title }
      key = { item.props.Key }
      accordionDataParent = { '#' + this.props.id }>
        { item }
      </CollapsingPanel>
    )
  }

  renderChildren() {
    return renderItems(this.props.children, this.renderInPanel)
  }

  render() {
    return (
      <div className = 'panel-group' id = { this.props.id }>
        { this.renderChildren() }
      </div>
    )
  }
}
