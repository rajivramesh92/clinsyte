class CheckBoxSwitch extends Component {

  constructor(props) {
    super(props);
    this.state = {
      checked: this.props.mode
    }
    this.handleOnChange = this.handleOnChange.bind(this);

  }

  componentWillUpdate(nextProps, nextState) {

    if(this.props.callback && nextState.checked != this.state.checked) {
      this.props.callback(nextState.checked)
    }
  }

  handleOnChange(event) {
    this.setState({
      checked: this.refs.checkbox.checked
    })
  }

  render() {
    return (
      <div className = { this.props.className }>
        <label className = 'checkbox-switch'>
          <input type = 'checkbox'
            ref = 'checkbox'
            checked = { this.state.checked }
            onChange =  { this.handleOnChange }
          />
          <span className = 'animation'>
            <div className = 'animation'></div>
          </span>
        </label>
      </div>
    )
  }
}

CheckBoxSwitch.propTypes = {
  mode: PropTypes.bool.isRequired,
  callback: PropTypes.func,
  className: PropTypes.string
}
