const LineBoxChart = (props) => {

  var getData = () => {
    var data = [...props.data];
    data.unshift(['Category', 'Minimum', 'Average', 'Maximum']);
    return data;
  }

  var getColumn = (id, columnIndex) => {
    return {
      id,
      type: 'number',
      role: 'interval',
      calc: (dt, row) => {
        return dt.getValue(row, columnIndex + 1)
      }
    };
  }

  var getAnnotation = (id, columnIndex) => {
    return {
      id: id + '_annot',
      calc: 'stringify',
      sourceColumn: columnIndex + 1,
      type: 'string',
      role: 'annotation'
    };
  }

  var options = {
    intervals: {
      style: 'boxes',
      fillOpacity: 0.75,
      color: '#00CDFF'
    },
    interval: {
      avg: {
        style: 'points',
        fillOpacity: 1,
        color: '#000000'
      }
    },
    lineWidth: 0,
    series: {
      0: {
        visibleInLegend: false,
        enableInteractivity: false,
        color: 'black'
      },
      1: {
        color: 'black'
      },
      2: {
        color: 'black'
      }
    },
    legend: {
      position: 'none'
    },
    bar: {
      groupWidth: '100%'
    }
  }

  var drawChart = () => {
    var data = google.visualization.arrayToDataTable(getData());
    var view = new google.visualization.DataView(data);

    var columnIds = ['min', 'avg', 'max'];
    var columns = _.map(columnIds, getColumn);
    var annotations = _.map(columnIds, getAnnotation);

    annotations.splice(1, 0, 2);
    annotations.splice(3, 0, 3);
    view.setColumns([0, 1].concat(columns, annotations));

    var chart = new google.visualization.LineChart(document.getElementById(props.name));
    chart.draw(view, options);
  }

  return (
    <Chart name = { props.name }
      className = { props.className }
      drawChart = { drawChart }
    />
  );
}

LineBoxChart.propTypes = {
  name: PropTypes.string.isRequired,
  data: PropTypes.array.isRequired,
  className: PropTypes.string
}
