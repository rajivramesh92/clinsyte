class ScrollingList extends Component {

  componentDidMount() {
    var props = this.props;
    $('#' + props.name).slimScroll({
      height: props.height + 'px',
      width: props.width + 'px'
    })
  }

  render() {
    return (
      <div id = { this.props.name }
        className = { this.props.className }>
        { this.props.children }
      </div>
    );
  }
}

ScrollingList.propTypes = {
  name: PropTypes.string.isRequired,
  height: PropTypes.number,
  width: PropTypes.number,
  className: PropTypes.string
}
