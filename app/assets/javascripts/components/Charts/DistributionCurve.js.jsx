const DistributionCurve = (props) => {

  var drawChart = () => {
    var table = google.visualization.arrayToDataTable(props.data);

    var options = {
      title: props.title,
      ...commonOptions,
      colors: [...customizedColors]
    };

    var chart = new google.visualization.LineChart(document.getElementById(props.name));

    chart.draw(table, options);
  }

  return (
    <Chart name = { props.name }
      className =  { props.name }
      drawChart = { drawChart }
    />
  )

}

DistributionCurve.propTypes = {
  name: PropTypes.string.isRequired,
  data: PropTypes.array.isRequired,
  title: PropTypes.string.isRequired,
  className: PropTypes.string
}
