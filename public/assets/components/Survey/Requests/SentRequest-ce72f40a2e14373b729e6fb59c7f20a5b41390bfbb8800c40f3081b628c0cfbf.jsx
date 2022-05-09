class SentRequest extends Component {

  render() {
    var request = this.props.request;
    return (
      <div className = { this.props.className }>
        <div className = 'col-sm-4 blue text-mobile-center'>
          <ChartLink user = { request.receiver }/>
        </div>
        <div className = 'col-sm-4 text-center'>
          <Icon icon = { TIME_ICON } />&nbsp;
          Sent: <i>{ request.sent_at ? moment(request.sent_at).format('LLL') : '-'  }</i>
        </div>
        <div className = 'col-sm-4'>
          {
            request.state === 'submitted' ?
            <Link to = { '/surveys/'+ this.props.surveyId +'/response/' + request.id }
              className = 'pull-right'>
              <Icon icon = { VIEW_ICON }/>
              View
            </Link> : null
          }
        </div>
      </div>
    )
  }
}

SentRequest.propTypes = {
  request: PropTypes.object.isRequired,
  surveyId: PropTypes.oneOfType([
    PropTypes.number,
    PropTypes.string
  ]).isRequired,
  className: PropTypes.string
}
