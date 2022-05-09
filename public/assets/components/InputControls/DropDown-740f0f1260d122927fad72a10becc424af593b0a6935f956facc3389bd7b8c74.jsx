class DropDown extends Component {

  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);
  }

  onChange(event){
    event.preventDefault();
    if(this.props.onChange){
      this.props.onChange(this.refs.dropDown.value);
    }
  }

  getOptionMarkup(option) {
    return <option value = { option.value } key = { option.key }> { option.display } </option>
  }

  renderAllOptions() {
    return renderItems(this.props.options, this.getOptionMarkup);
  }

  getValue() {
    return this.refs.dropDown.value;
  }

  render() {
    return (
      <select className = { this.props.className }
        ref = 'dropDown'
        defaultValue = { this.props.defaultVal }
        onChange = { this.onChange }
        disabled = { this.props.disabled }>
        { this.renderAllOptions() }
      </select>
    );
  }
}

DropDown.propTypes = {
  options: PropTypes.arrayOf(PropTypes.shape({
    value: PropTypes.oneOfType([ PropTypes.number, PropTypes.string ]),
    key: PropTypes.oneOfType([ PropTypes.number, PropTypes.string ]),
    display: PropTypes.oneOfType( [PropTypes.number, PropTypes.string ]),
  })).isRequired,
  onChange: PropTypes.func,
  defaultVal: PropTypes.oneOfType([ PropTypes.number, PropTypes.string ]),
  disabled: PropTypes.bool,
  className: PropTypes.string
}
