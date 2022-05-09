class SurveyNameForm extends Component {

  constructor(props) {
    super(props);
    this.state = {
      name: this.props.name
    }
    this.onChange = this.onChange.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      name: nextProps.name
    })
    this.render();
  }

  onChange(event) {
    this.setState({
      name: event.currentTarget.value
    })
  }

  getName() {
    return this.refs.name.value;
  }

  render() {
    return (
      <div className = 'form-group'>
        <small className = 'blue '>
          Survey Name
        </small>
        <input type = 'text'
          className = 'form-control'
          ref = 'name'
          value = { this.state.name }
          onChange = { this.onChange }
        />
      </div>
    )
  }
}

SurveyNameForm.propTypes = {
  name: PropTypes.string
}
