class EditMedication extends Component {

  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);
    this.nameSuggestionTemplate = this.nameSuggestionTemplate.bind(this);
    this.suggestionSource = this.suggestionSource.bind(this);
  }

  onChange(event, medication) {
    this.props.onChange({
      name: this.refs.name.getValue(),
      description: this.refs.description.value,
      id: this.refs.id.value
    })
  }

  nameSuggestionTemplate(medication) {
    return this.props.suggestionTemplate(medication, 'name');
  }

  suggestionSource(query, syncCallback, asyncCallback) {
    this.props.suggestionSource(query, 'medications', syncCallback, asyncCallback)
  }

  render() {
    return (
      <div className = 'medication-divisions vertically-centered'>
        <div className = 'col-sm-6 margin-top-7 no-padding'>
          <AutoSuggest source = { this.suggestionSource }
            placeholder = 'Name'
            displayKey = { (medication) => { return medication.name } }
            suggestionTemplate = { this.nameSuggestionTemplate }
            onSelectHandler = { this.onChange }
            name = { this.props.autoSuggestNameName }
            defaultValue = { this.props.medication.name }
            ref = 'name'
            onChange = { this.onChange }
          />
        </div>
        <div className = 'col-sm-6 margin-top-7 no-padding'>
          <input type = 'text'
            placeholder = 'Description'
            defaultValue = { this.props.medication.description }
            onChange = { this.onChange }
            className = 'full-width'
            ref = 'description'
          />
        </div>
        <input type = 'hidden'
          defaultValue = { this.props.medication.id }
          ref = 'id'
        />
      </div>

    )
  }
}

EditMedication.propTypes = {
  autoSuggestNameName: PropTypes.string.isRequired,
  suggestionTemplate: PropTypes.func.isRequired,
  suggestionSource: PropTypes.func.isRequired,
  onChange: PropTypes.func.isRequired
}
