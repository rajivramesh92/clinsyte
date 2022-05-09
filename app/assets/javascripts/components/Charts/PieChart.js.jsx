const PieChart = (props) => {

  var drawChart = () => {
    var data = google.visualization.arrayToDataTable(props.data)

    var options = {
      title: props.title,
      sliceVisibilityThreshold: 0.05,
      pieHole: 0.3,
      pieSliceTextStyle: {
        fontSize: 8
      },
      ...commonOptions,
      colors: [...customizedColors]
    }

    var chart = new google.visualization.PieChart(document.getElementById(props.name));
    chart.draw(data, options)
  }

  return (
    <Chart name = { props.name }
      className = { props.className }
      drawChart = { drawChart }
    />
  )
}

PieChart.propTypes = {
  name: PropTypes.string.isRequired,
  data: PropTypes.array.isRequired,
  title: PropTypes.string.isRequired,
  className: PropTypes.string
}
