var Provider = ReactRedux.Provider;
var createStore = Redux.createStore;

class Root extends Component {
  render() {
    return (
      <div>
        { this.props.token ? <MedicineAlertManager/> : null }
        <Header history = { this.props.history }/>
        {this.props.children}
      </div>
    )
  }
}

var maptStateToProps = (state) => {
  return {
    token: state.auth.token
  }
}

Root = connect(maptStateToProps)(Root);
