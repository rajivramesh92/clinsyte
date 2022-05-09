/**
 * following component renders the facility for creating Questions following are the question category codes
 * plain_text - stands for plain text or descriptive questions
 * multiple_choice - stands for multiple choice questions
 * range_based - stands for range based questions
 */

class QuestionInput extends Component {

  constructor(props) {
    super(props);
    var categories = QUESTION_CATEGORIES;
    var category = DEFAULT_CATEGORY;
    this.state = {
      category
    }

    this.categoryOptions = _.map(categories, (category, index) => {
      return {
        value: category,
        display: titleFromSnake(category),
        key: category
      }
    })

    this.handleCategoryChange = this.handleCategoryChange.bind(this);
  }

  getQuestion() {
    var specifications = this.refs.specifications;
    return {
      description: this.refs.question.value,
      attrs: specifications ? specifications.getAttributes() : null,
      category: this.state.category
    }
  }

  handleCategoryChange(category) {
    this.setState({
      category
    })
  }

  render() {
    return (
      <div>
        <div className = 'form-group'>
          <span className = 'full-width no-margin'>
            <span className = 'pull-right'>
              <span onClick = { this.props.onRemove }
                title = 'Remove'
                className = 'cursor-pointer red'>
                <Icon icon = { DELETE_ICON }/>
                </span>
            </span>
            <span className = 'pull-left'>
              <small className = 'blue'>
                Question { this.props.serialNo }
              </small>
            </span>
          </span>
          <textarea className = { 'form-control' }
            rows = '2'
            ref = 'question'>
          </textarea>
        </div>
        <div className = 'row'>
          <div className = 'col-sm-12'>
            <label className = 'blue'>
              Type:&nbsp;&nbsp;
            </label>
            <DropDown options = { this.categoryOptions }
              className = 'form-control'
              onChange = { this.handleCategoryChange }
            />
            <label className = 'blue margin-top-15'>
              Question Spefications
            </label>
            <div>
              <QuestionSpecifications ref = 'specifications'
                category = { this.state.category }
                lists = { this.props.lists }
              />
            </div>
          </div>
        </div>
      </div>
    )
  }
}

QuestionInput.propTypes = {
  onRemove: PropTypes.func.isRequired,
  serialNo: PropTypes.number
}
