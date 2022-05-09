const ComparisonChart = ({ name, title, data, className }) => {

  var drawChart = () => {
    var chartData = google.visualization.arrayToDataTable(data);
    var options = { title };

    var chart = new google.visualization.ColumnChart(document.getElementById(name));
    chart.draw(chartData, options);
  }

  return (
    <Chart name = { name }
      className = { className }
      drawChart = { drawChart }
    />
  )
}

ComparisonChart.propTypes = {
  name: PropTypes.string.isRequired,
  title: PropTypes.string.isRequired,
  data: PropTypes.array.isRequired,
  className: PropTypes.string
}
