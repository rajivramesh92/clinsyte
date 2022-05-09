class EditTherapy extends Component {

  constructor(props) {
    super(props);
    this.onSelect = this.onSelect.bind(this);
    this.suggestionSource = this.suggestionSource.bind(this);
    this.suggestionTemplate = this.suggestionTemplate.bind(this);
  }

  onSelect(event, therapy) {
    this.props.onSelect({
      name: therapy.name,
      strain_id: therapy.id,
      id: this.refs.id.value
    })
  }

  suggestionSource(query, syncCallback, asyncCallback) {
    this.props.suggestionSource(query, 'therapies', syncCallback, asyncCallback)
  }

  suggestionTemplate(therapy) {
    return this.props.suggestionTemplate(therapy, 'name');
  }

  render() {
    return (
      <div className = 'therapies-edit'>
        <AutoSuggest source = { this.suggestionSource }
          placeholder = 'Name'
          className = { this.props.autoSuggestClassName }
          ref = 'therapy'
          displayKey = { (therapy) => { return therapy.name } }
          suggestionTemplate = { this.suggestionTemplate }
          onSelectHandler = { this.onSelect }
          name = { this.props.autoSuggestName }
          defaultValue = { this.props.therapy.name }
        />
        <input type = 'hidden'
          defaultValue = { this.props.therapy.id }
          ref = 'id'
        />
      </div>
    )
  }
}

EditTherapy.propTypes = {
  autoSuggestName: PropTypes.string.isRequired,
  suggestionTemplate: PropTypes.func.isRequired,
  suggestionSource: PropTypes.func.isRequired,
  onSelect: PropTypes.func.isRequired,
  therapy: PropTypes.object,
  autoSuggestClassName: PropTypes.string
}
