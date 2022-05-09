const StackedBarChart = (props) => {

  var drawChart = () => {
    var data = google.visualization.arrayToDataTable(props.data);

    var options = {
      title: props.title,
      isStacked: true,
      sliceVisibilityThreshold: 0,
      ...commonOptions,
      colors: [...customizedColors],
      bar: {
        groupWidth: '30%'
      }
    }

    var chart = new google.visualization.ColumnChart(document.getElementById(props.name));
    chart.draw(data, options);
  }

  return (
    <Chart name = { props.name }
      className = { props.className }
      drawChart = { drawChart }
    />
  )
}

StackedBarChart.propTypes = {
  name: PropTypes.string.isRequired,
  data: PropTypes.array.isRequired,
  title: PropTypes.string.isRequired,
  className: PropTypes.string
}
