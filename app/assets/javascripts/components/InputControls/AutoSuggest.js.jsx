class AutoSuggest extends Component {

  constructor(props) {
    super(props);
    this.isSearching = this.isSearching.bind(this);
  }

  componentDidMount() {
    $('#' + this.props.name).typeahead({
      selectable: true,
      classNames: {
        cursor: 'is-selected'
      }
    },
    {
      name: 'source',
      source: this.props.source,
      templates: {
        suggestion: this.props.suggestionTemplate || undefined
      },
      displayKey: this.props.displayKey || undefined,
      hint: false
    })
    .on('typeahead:select', this.props.onSelectHandler)
  }

  getValue() {
    return this.refs.inputValue.value;
  }

  clearValue() {
    this.refs.inputValue.value = '';
  }

  isSearching(){
    if( this.props.isLoading ){
      return ( <i className='search-spinner form-control-feedback'></i> );
    }
  }

  render() {
    return (
      <div className = 'has-feedback'>
        <input
          type = 'text'
          className = { 'typeahead ' + (this.props.className || '') }
          id = { this.props.name }
          placeholder = { this.props.placeholder }
          ref = 'inputValue'
          defaultValue = { this.props.defaultValue }
          onChange = { this.props.onChange }
        />
        { this.isSearching() }
      </div>
    )
  }
}

AutoSuggest.propTypes = {
  source: PropTypes.func.isRequired,
  onSelectHandler: PropTypes.func.isRequired,
  name: PropTypes.string.isRequired,
  suggestionTemplate: PropTypes.func,
  placeholder: PropTypes.string,
  displayKey: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.func
  ]),
  isLoading: PropTypes.bool,
  defaultValue: PropTypes.string,
  className: PropTypes.string,
  onChange: PropTypes.func
}
