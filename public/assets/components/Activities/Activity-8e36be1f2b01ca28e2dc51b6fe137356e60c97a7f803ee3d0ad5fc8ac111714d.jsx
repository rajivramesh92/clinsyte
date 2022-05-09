class Activity extends Component {

  renderActionIcon() {
    var action = this.props.activity.action;
    bgFromAction = {
      create: 'green-bg',
      update: 'blue-bg',
      destroy: 'red-bg'
    }

    return <div className = { 'circle-shape ' + bgFromAction[action] }></div>
  }

  renderOwner() {
    var owner = this.props.activity.owner
    return(
      <div className = 'activity-owner'>
        <div className = 'activity-owner-icon'>
          <UserIcon user = { owner }/>
        </div>
        <div className = 'activity-owner-name'>
          { this.props.activity.owner.name }
        </div>
      </div>
    )
  }

  renderMessage() {
    return this.props.activity.message;
  }

  renderTimestamp() {
    var time = Number(this.props.activity.timestamp);
    return (
      <span className = 'activity-timestamp text-right'>
        <div className = 'row text-mobile-center hidden-md hidden-lg'>
          <div className = 'col-xs-6'>
            { moment(time).format('DD MMMM YYYY') + ' ' }
          </div>
          <div className = 'col-xs-6'>
            { ' ' + moment(time).format('hh:mma') }
          </div>
        </div>
        <div className = 'visible-md-inline-block visible-lg-inline-block'>
          { moment(time).format('DD MMMM YYYY') + ' ' + moment(time).format('hh:mma') }
        </div>
      </span>
    )
  }

  renderActivity() {
    return (
        <div>
          <div className = 'vertically-centered'>
            { this.renderActionIcon() }
          </div>
          <div className = 'vertically-centered full-width'>
            <div className = 'col-md-2 col-xs-12'>
              { this.renderOwner() }
            </div>
            <div className = 'col-md-8 col-xs-12 margin-top-7 break-all-word'>
              { this.renderMessage() }
            </div>
            <div className = 'col-md-2 col-xs-12 text-right margin-top-7'>
              { this.renderTimestamp() }
            </div>
          </div>
        </div>
      )
  }

  render() {
    return (
        <div className = { this.props.className }>
          { this.renderActivity() }
        </div>
      )
  }
}

Activity.propTypes = {
  activity: PropTypes.object.isRequired,
  className: PropTypes.string
}
