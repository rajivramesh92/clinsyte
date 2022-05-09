class ResponseViewList extends Component {

  renderResponseView(attributes, index) {
    if (attributes.question.status !== 'inactive') {
      return (
        <div key = { attributes.question.id }
          className = 'list-group-item'>
          <ResponseView question = { attributes.question }
            response = { attributes.response }
            serialNo = { index + 1 }
          />
        </div>
      );
    }
  }

  render() {
    return (
      <div className = 'list-group'>
        { renderItems(this.props.attributes, this.renderResponseView) }
      </div>
    )
  }
}

ResponseViewList.propTypes = {
  attributes: PropTypes.array.isRequired
}
