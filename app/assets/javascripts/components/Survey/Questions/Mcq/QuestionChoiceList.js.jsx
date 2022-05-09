/**
 * component renders the list of QuestionChoice component for given number of choices
 */
class QuestionChoiceList extends Component {

  constructor(props) {

    super(props);

    var noOfChoices = MIN_CHOICE_IN_MCQ;
    this.state = {
      choices: createObjects(noOfChoices, { option: '' })
    }

    this.renderChoice = this.renderChoice.bind(this);
    this.handleChangeInOption = this.handleChangeInOption.bind(this);
    this.handleOnAddClick = this.handleOnAddClick.bind(this);
    this.handleOnDeleteClick = this.handleOnDeleteClick.bind(this);

  }

  getAttributes() {
    return this.state.choices;
  }

  handleOnDeleteClick(delIndex) {
    return (event) => {
      var choices =_.reject(this.state.choices, (choice, index) => {
        return delIndex === index;
      })
      this.setState({ choices })
    }
  }

  handleChangeInOption(choiceIndex) {
    return (option) => {
      var choices = [...this.state.choices];
      choices[choiceIndex].option = option;
      this.setChoices(choices)
    }
  }

  handleOnAddClick(event) {
    var choices = [...this.state.choices].concat({ option: '' })
    this.setChoices(choices);
  }

  setChoices(choices) {
    this.setState({
      choices
    })
  }

  renderDelButton(index) {
    if( this.state.choices.length > MIN_CHOICE_IN_MCQ ) {
      return (
        <span onClick = { this.handleOnDeleteClick(index) }
          className = 'red cursor-pointer'>
          <Icon icon = { DELETE_ICON }/>
        </span>
      )
    }
  }

  renderAddButton() {
    count = this.state.choices.length
    if(count >= MAX_CHOICE_IN_MCQ) {
      return;
    }
    else {
      return (
        <div onClick = { this.handleOnAddClick }
          className = 'margin-top-7 pull-right cursor-pointer blue'>
          <Icon icon = { ADD_ICON }/>&nbsp;Add
        </div>
      )
    }
  }

  renderChoice(choice, index) {
    var props = this.props;
    return (
      <div key = { index + choice.option }>
        <QuestionChoice option = { choice.option }
          onBlur = { this.handleChangeInOption(index) }
          textClassName = 'question-choice'
        />
        { this.renderDelButton(index) }
      </div>
    )
  }

  renderChoices() {
    return renderItems(this.state.choices, this.renderChoice)
  }

  render() {
    return (
      <div>
        { this.renderChoices() }
        { this.renderAddButton() }
      </div>
    )
  }
}
