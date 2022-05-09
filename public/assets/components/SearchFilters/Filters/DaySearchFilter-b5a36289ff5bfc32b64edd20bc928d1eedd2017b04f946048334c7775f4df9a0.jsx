class DaySearchFilter extends Component {

  constructor(props) {
    super(props);
    this.state = {
      selectedValue: this.props.defaultValue || null,
      dateSelectClass: this.getDateSelectClass(this.props.defaultValue)
    }
    this.onChange = this.onChange.bind(this);
    this.handleSinceDateOnChage = this.handleSinceDateOnChage.bind(this);
  }

  getOptions() {
    var dayFilters = [ 'in last 30 days', 'in last 3 months', 'in last 6 months', 'in last 1 year', 'since...']
    return _.map(dayFilters, filter => {
      return {
        value: filter,
        label: filter
      }
    })
  }

  getDateSelectClass(selectValue) {
    return 'margin-top-15 ' + (selectValue === 'since...' ? '' : 'opacity-0');
  }

  onChange(newSelect) {
    selectedValue = newSelect ? newSelect.value : null;
    dateSelectClass = this.getDateSelectClass(selectedValue);

    this.setState({
      selectedValue,
      dateSelectClass
    })
    if(newSelect && newSelect.value === 'since...') {
      newSelect.value = moment(this.refs.sinceDate.getDate()).format('DD/MM/YYYY')
    }
    if(this.props.onChange) {
      this.props.onChange(newSelect || { value: '' });
    }
  }

  handleSinceDateOnChage(date) {
    this.onChange({ value: this.state.selectedValue })
  }

  render() {
    var today = new Date();
    defaultDate = { date: today.getDate(), month: today.getMonth() + 1, year: today.getFullYear() }
    return (
      <span>
        <Select name = 'form-field-name'
          placeholder = { this.props.placeholder || 'Search from when...' }
          options = { this.getOptions() }
          value = { this.state.selectedValue }
          onChange = { this.onChange }
          searchable = { false }
        />
        <DateSelect wrapperClass = { this.state.dateSelectClass }
          start = { 1970 }
          end = { 2016 }
          className = 'col-md-4'
          ref = 'sinceDate'
          onChange = { this.handleSinceDateOnChage }
          defaultDate = { defaultDate }
        />
      </span>
    )
  }
}

DaySearchFilter.propTypes = {
  onChange: PropTypes.func,
  defaultValue: PropTypes.string,
  placeholder: PropTypes.string
}
