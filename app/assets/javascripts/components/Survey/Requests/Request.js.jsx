class Request extends Component {

  constructor(props) {
    super(props);
    this.renderActions = this.renderActions.bind(this);
  }

  renderActions(state, requestId, surveyId) {

    var getAction = (action) => {
      var icon = action === 'view' ? VIEW_ICON : SUBMIT_ICON;
      return (
        <span>
          <Icon icon = { icon }/>
          &nbsp;
          { capitalize(action) }
        </span>
      )
    }

    return (
      <Link to = { '/surveys/' + surveyId + '/response/' + requestId }>
        { state === 'submitted' ? getAction('view') : getAction('submit') }
      </Link>
    )
  }

  render() {
    var request = this.props.request
    var survey = request.survey
    return (
      <div>
        <div className = 'vertically-centered font-bold'>
          { this.props.serialNo }.&nbsp;&nbsp;
        </div>
        <div className = 'vertically-centered font-size-14 full-width text-capitalize'>
          { survey.name }&nbsp;
          <em className = 'font-size-11 text-lowercase'>
            Sent at - { moment(request.sent_at).format('LLL') }
          </em>
          <span className = 'pull-right font-size-14'>
            { this.renderActions(request.state, request.id, survey.id) }
          </span>
        </div>
      </div>
    )
  }
}

Request.propTypes = {
  request: PropTypes.object.isRequired,
  serialNo: PropTypes.number
}
