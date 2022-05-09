class McqResponse extends Component {

  constructor(props) {
    super(props);
    this.state = {
      selected: null
    }
    this.renderResponseChoice = this.renderResponseChoice.bind(this);
    this.changeSelection = this.changeSelection.bind(this);
  }

  getResponse() {
    return [this.state.selected]
  }

  changeSelection(selected) {
    return (event) => {
      this.setState({
        selected
      })
    }
  }

  renderResponseChoice(choice) {
    selected = this.state.selected;
    return (
      <div className = 'form-group'
        key = { choice.id }>
        <div className = 'radio'>
          <label>
            <input type = 'radio'
              checked = { selected === choice.id }
              onClick = { this.changeSelection(choice.id) }
            />&nbsp;&nbsp;
            { choice.option }
          </label>
        </div>
      </div>
    )
  }

  render() {
    return (
      <div>
        { renderItems(this.props.choices, this.renderResponseChoice) }
      </div>
    )
  }
}

McqResponse.propTypes = {
  choices: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.oneOfType([ PropTypes.number, PropTypes.string ]).isRequired,
    option: PropTypes.string.isRequired
  })).isRequired
}
