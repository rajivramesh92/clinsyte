class Chart extends Component {

  componentDidMount() {
    google.charts.setOnLoadCallback(this.props.drawChart)
  }

  componentDidUpdate() {
    google.charts.setOnLoadCallback(this.props.drawChart)
  }

  render() {
    return (
      <div id = { this.props.name }
        className = { this.props.className }></div>
    )
  }
}

Chart.propTypes = {
  name: PropTypes.string.isRequired,
  drawChart: PropTypes.func.isRequired,
  className: PropTypes.string
}
