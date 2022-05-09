class CollapsingPanel extends Component {

  constructor(props) {
    super(props);
    this.collapsingId = _.uniqueId('collapsing-panel-');
  }

  render() {
    var { expand } = this.props;
    return (
      <div className = 'panel panel-default'>
        <div className = 'panel-heading'>
          <h4 className = 'panel-title'>
            <a data-toggle = 'collapse'
              href = { '#' + this.collapsingId }
              data-parent = { this.props.accordionDataParent || null }>
                { this.props.title }
            </a>
          </h4>
        </div>
        <div id = { this.collapsingId }
          className = { 'panel-collapse collapse' + (expand ? ' in' : '') } >
            <div className = 'panel-body'>
              { this.props.children }
            </div>
        </div>
      </div>
    )
  }
}

CollapsingPanel.propTypes = {
  expand: PropTypes.bool
}
