const TherapyCompoundChart = ({ compounds, chartName }) => {

  var getData = () => {
    return _.map(compounds, compound => {
      var details = compound.details;
      return [compound.name, details.low, details.average, details.high];
    });
  }

  return (
    <LineBoxChart name = { chartName }
      data = { getData() }
    />
  )
}

TherapyCompoundChart.propTypes = {
  compounds: PropTypes.array.isRequired,
  chartName: PropTypes.string.isRequired
}
