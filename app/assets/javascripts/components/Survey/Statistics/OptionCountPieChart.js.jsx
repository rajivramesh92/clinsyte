const OptionCountPieChart = ({ id, stats }) => {

  var isResponseEmpty = (response) => {
    return _.isEmpty(_.compact(_.toArray(_.object(_.rest(stats[response])))));
  }

  var renderPieChart = (name, title, response) => {
    if (isResponseEmpty(response)) {
      return <p className = 'red small'>{ 'Data insufficient from ' + title.toLowerCase() + ' to plot pie chart'  }</p>;
    }
    else {
      return (
        <PieChart name = { name }
          title = { title }
          data = { stats[response] }
        />
      );
    }
  }

  return (
    <div>
      { stats.patientResponse ? renderPieChart( id + 'patientPieChart', 'Patient response', 'patientResponse') : '' }
      { stats.careteamResponse ? renderPieChart( id + 'careteamPieChart', 'Careteam patients response', 'careteamResponse' ) : '' }
      { stats.globalResponse ? renderPieChart( id + 'globalPieChart', 'Clinsyte population response', 'globalResponse'): '' }
    </div>
  );
}

OptionCountPieChart.propTypes = {
  id: PropTypes.oneOfType([
    PropTypes.string, PropTypes.number
  ]).isRequired,
  stats: PropTypes.shape({
    careteamResponse: PropTypes.array,
    globalResponse: PropTypes.array,
    patientResponse: PropTypes.array
  }).isRequired
}
