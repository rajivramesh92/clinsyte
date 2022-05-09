class EditSymptom extends Component {

  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);
    this.suggestionTemplate = this.suggestionTemplate.bind(this);
    this.suggestionSource = this.suggestionSource.bind(this);
  }

  onChange(event, symptom) {
    this.props.onChange({
      name: this.refs.name.getValue(),
      id: this.refs.id.value
    })
  }

  suggestionSource(query, syncCallback, asyncCallback) {
    this.props.suggestionSource(query, 'symptoms', syncCallback, asyncCallback);
  }

  suggestionTemplate(symptom) {
    return this.props.suggestionTemplate(symptom, 'name')
  }

  render() {
    return (
      <div className = 'symptoms symptoms-input'>
        <div className = 'margin-top-7'></div>
        <AutoSuggest source = { this.suggestionSource }
          placeholder = 'Name'
          ref = 'name'
          displayKey = { (symptom) => { return symptom.name } }
          suggestionTemplate = { this.suggestionTemplate }
          onSelectHandler = { this.onChange }
          name = { this.props.autoSuggestName }
          defaultValue = { this.props.symptom.name }
          onChange = { this.onChange }
        />
        <input type = 'hidden'
          defaultValue = { this.props.symptom.id }
          ref = 'id'
        />
      </div>
    )
  }
}

EditSymptom.propTypes = {
  autoSuggestName: PropTypes.string.isRequired,
  suggestionTemplate: PropTypes.func.isRequired,
  suggestionSource: PropTypes.func.isRequired,
  onChange: PropTypes.func.isRequired
}
