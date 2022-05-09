class DefaultHome extends Component {

  render() {
    return (
      <div className = 'row'>
        <div className = 'col-md-5'>
          <Greeting user = { this.props.user } />
        </div>
      </div>
    )
  }
}

DefaultHome.propTypes = {
  user: PropTypes.object.isRequired
}
