class ActivityList extends Component {

  constructor(props) {
    super(props);
    this.renderActivity = this.renderActivity.bind(this);
    this.renderActivityList = this.renderActivityList.bind(this);
  }

  renderActivity(activity, index) {
    return (
      <Activity activity = { activity }
        key = { index }
        className = { this.props.activityClassName }
      />
    )
  }

  renderActivityList(){
    if ( _.isEmpty(this.props.activities) ){
      return (
        <NoItemsFound icon = { ACTIVITIES_ICON }
          message = 'No activities found'
        />
      );
    }
    else{
      return renderItems(this.props.activities, this.renderActivity);
    }
  }

  render() {
    return (
      <div className = { this.props.className }>
        <h5 className = 'text-center'>
          { this.props.activityName }
        </h5>
        { this.renderActivityList() }
      </div>
    )
  }
}

ActivityList.propTypes = {
  activities: PropTypes.array.isRequired,
  activityName: PropTypes.string,
  activityClassName: PropTypes.string,
  className: PropTypes.string
}
