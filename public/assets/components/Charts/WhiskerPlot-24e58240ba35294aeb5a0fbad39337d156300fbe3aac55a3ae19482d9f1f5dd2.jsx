const WhiskerPlot = (props) => {

  var addColumns = (table) => {
    table.addColumn('string', 'x');
    table.addColumn('number', 'range_minimum');

    var columnIds = ['min', 'firstQuartile', 'median', 'thirdQuartile', 'max'];
    var type = 'number';
    var role = 'interval';

    _.each(columnIds, id => {
      table.addColumn({ id, type, role });
    })

    table.addColumn('number', 'range_maximum');

    return table;
  };

  var addRows = (table) => {
    var data = props.data;

    var rows = _.map(data, datum => {
      return [].concat(_.first(datum), datum[1], _.rest(datum), _.last(datum));
    });

    table.addRows(rows);

    return table;
  }

  var getView = (table) => {

    var getAnnotation = (sourceColumn) => {
      return {
        sourceColumn,
        role: 'annotation'
      };
    }

    var visibleCols = [0, 1, getAnnotation(1), 2,  3, 4, 5, 6, 7, getAnnotation(6)];
    var view = new google.visualization.DataView(table);
    view.setColumns(visibleCols);

    return view;
  }

  var barOptions = {
    fillOpacity: 1,
    color: '#000'
  }

  var options = {
    ...commonOptions,
    title:props.title,
    height: 500,
    legend: {
      position: 'none'
    },
    hAxis: {
      gridlines: {
        color: '#fff'
      }
    },
    lineWidth: 0,
    pointSize: 0,
    intervals: {
      barWidth: 0.5,
      boxWidth: 0.5,
      lineWidth: 2,
      fillOpacity: 1,
      style: 'boxes'
    },
    interval: {
      max: {
        style: 'points',
        ...barOptions
      },
      min: {
        style: 'points',
        ...barOptions
      },
      firstQuartile: {
        color: '#2196F3'
      },
      median: {
        style: 'points',
        ...barOptions
      }
    }
  };

  var drawChart = () => {
    var table = new google.visualization.DataTable();

    table = addColumns(table);
    table = addRows(table);
    var view = getView(table);

    var chart = new google.visualization.LineChart(document.getElementById(props.name));
    chart.draw(view, options);
  }

  return (
    <Chart name = { props.name }
      className = { props.className }
      drawChart = { drawChart }
    />
  )
}

WhiskerPlot.propTypes = {
  name: PropTypes.string.isRequired,
  data: PropTypes.array.isRequired,
  title: PropTypes.string,
  className: PropTypes.string
}
