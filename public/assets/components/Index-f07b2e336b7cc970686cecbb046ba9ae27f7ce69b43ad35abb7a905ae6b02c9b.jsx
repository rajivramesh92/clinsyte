class Index extends Component {

  componentDidMount() {
    if(this.props.message) {
      showToast(this.props.message, 'success', 4000)
      this.props.dispatch(unsetWelcome());
    }
    setTimeout(() => {
      hideToast()
    }, 4000);
  }

  render() {
    return (
        <div className = 'container'>
          <div className = 'row'>
            <div className = 'col-sm-12'>
              <h4>Welcome To { APP_NAME }</h4>
              <hr />
            </div>
          </div>
          <div className = 'row margin-top-15'>
            <div className = 'col-sm-4 col-sm-offset-4'>
              <LinkButton val = 'SIGN IN'
                to = '/sign_in'
              />
              <LinkButton val = 'SIGN UP'
                to = '/sign_up'
                className = 'btn btn-default btn-block'
              />
            </div>
          </div>
        </div>
      )
  }
}

mapStateToProps = (state) => {
  return {
    message: state.welcome.message
  };
}

Index = connect(mapStateToProps)(Index);
