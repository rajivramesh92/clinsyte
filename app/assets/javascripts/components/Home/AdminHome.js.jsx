class AdminHome extends Component {
  render(){
    return (
      <div className = 'row'>
        <div className = 'col-xs-12'>
          <div className = 'col-xs-6'>
            <Greeting user = { this.props.user } />
          </div>

          <div className = 'col-xs-6'>
            <AdminPanelLink/>
          </div>
        </div>
      </div>
    );
  }
}

AdminHome.propTypes = {
  user: PropTypes.object.isRequired
}
