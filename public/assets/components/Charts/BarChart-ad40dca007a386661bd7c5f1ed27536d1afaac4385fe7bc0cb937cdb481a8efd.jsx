const BarChart = (props) => {

  var drawChart = () => {
    var data = google.visualization.arrayToDataTable(props.data);

    var options = {
      title: props.title,
      isStacked: false,
      sliceVisibilityThreshold: 0,
      ...commonOptions,
      colors: [...customizedColors],
      bar: {
        groupWidth: '40%'
      },
      chartArea: {
        left: 75,
        width:'60%'
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

BarChart.propTypes = {
  name: PropTypes.string.isRequired,
  data: PropTypes.array.isRequired,
  title: PropTypes.string.isRequired,
  className: PropTypes.string
}
