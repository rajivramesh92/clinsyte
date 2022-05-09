class CategoryResponse extends Component {

  getResponse() {
    return this.refs.response.getResponse();
  }

  renderCategoryResponse() {
    var question = this.props.question;
    var category = question.category;
    if(category === PLAIN_TEXT) {
      return (
        <PlainTextResponse ref = 'response'
          className = { this.props.inputClassName }
        />
      )
    }
    else if (category === MULTIPLE_CHOICE) {
      return (
        <McqResponse ref = 'response'
          choices = { question.attrs }
        />
      )
    }
    else if (category === RANGE_BASED) {
      return (
        <RangeBasedResponse ref = 'response'
          id = { question.id }
          min = { question.attrs.min }
          max = { question.attrs.max }
        />
      )
    }
    else if (category === LIST_BASED) {
      return (
        <ListBasedResponse  ref = 'response'
          name = { question.id + 'list-based' }
          list = { question.attrs.list }
          category = { question.attrs.category }
        />
      );
    }
  }

  render() {
    return <div>{ this.renderCategoryResponse() } </div>
  }
}

CategoryResponse.propTypes = {
  inputClassName: PropTypes.string,
  question: PropTypes.object.isRequired
}
