class Greeting extends Component {
  render(){
    return (
      <h5>
        Welcome { this.props.user.name}
      </h5>
    );
  }
}

// PropTypes
Greeting.propTypes = {
  user: PropTypes.object.isRequired
}
