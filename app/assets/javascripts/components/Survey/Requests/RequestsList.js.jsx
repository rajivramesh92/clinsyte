class RequestsList extends Component {

  renderSurveyRquest(request, index) {
    if(request.survey) {
      return (
        <li className = 'list-group-item'
          key = { request.id }>
          <Request request = { request }
            serialNo = { index + 1 }
          />
        </li>
      )
    }
  }

  render() {
    var surveys = this.props.surveys
    return (
      <ul className = 'list-group'>
        {
          _.isEmpty(surveys) ?
          <NoItemsFound icon = { SURVEY_ICON }
            message = 'No survey requests'
          /> : renderItems(surveys, this.renderSurveyRquest)
        }
      </ul>
    )
  }
}

RequestsList.propTypes = {
  surveys: PropTypes.array.isRequired,
  className: PropTypes.string
}
