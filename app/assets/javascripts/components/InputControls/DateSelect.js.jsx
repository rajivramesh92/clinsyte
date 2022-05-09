var months = [
  { key: 0, value: 1, display: 'January' },
  { key: 1, value: 2, display: 'February' },
  { key: 2, value: 3, display: 'March' },
  { key: 3, value: 4, display: 'April' },
  { key: 4, value: 5, display: 'May' },
  { key: 5, value: 6, display: 'June' },
  { key: 6, value: 7, display: 'July' },
  { key: 7, value: 8, display: 'August' },
  { key: 8, value: 9, display: 'September' },
  { key: 9, value: 10, display: 'October' },
  { key: 10, value: 11, display: 'November' },
  { key: 11, value: 12, display: 'December' }
]

class DateSelect extends Component {

  constructor(props) {
    super(props);
    this.defaultDate  = this.props.defaultDate || { date: 1, month: 1, year: this.props.end }
    this.onChange = this.onChange.bind(this);
  }

  generateNumberedObject(start, end) {
    numberedObject = []
    for( var i = start; i <= end; i++) {
      numberedObject.push({ key: i, value: i, display: i});
    }
    return numberedObject;
  }

  getDate() {
    var year = this.refs.year.getValue();
    var month = this.refs.month.getValue() - 1;
    var date = this.refs.date.getValue();

    return new Date(year,month,date);
  }

  onChange() {
    if(this.props.onChange){
      this.props.onChange(this.getDate());
    }
  }

  render() {
    return (
      <div className = { this.props.wrapperClass }>
        <DropDown
          ref = 'month'
          reference = 'month'
          options = { months }
          className = { this.props.className }
          defaultVal = { this.defaultDate.month }
          onChange = { this.onChange }
        />
        <DropDown
          ref = 'date'
          reference = 'date'
          options = { this.generateNumberedObject(1,31) }
          className = { this.props.className }
          defaultVal = { this.defaultDate.date }
          onChange = { this.onChange }
        />
        <DropDown
          ref = 'year'
          reference = 'year'
          options = { this.generateNumberedObject(this.props.start, this.props.end) }
          className = { this.props.className }
          defaultVal = { this.defaultDate.year }
          onChange = { this.onChange }
        />
      </div>
    )
  }
}

DateSelect.propTypes = {
  start: PropTypes.number.isRequired,
  end: PropTypes.number.isRequired,
  onChange: PropTypes.func,
  className: PropTypes.string,
  wrapperClass: PropTypes.string,
  defaultDate: PropTypes.object
}
