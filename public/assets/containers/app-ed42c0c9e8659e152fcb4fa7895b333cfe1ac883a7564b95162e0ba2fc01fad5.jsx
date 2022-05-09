var Provider = ReactRedux.Provider;
var createStore = Redux.createStore;

var initialState = window.__INITIAL_STATE || null
if(initialState.appointmentPreference) {
  initialState.appointmentPreference.autoConfirm = initialState.appointmentPreference.auto_confirm;
  delete initialState.appointmentPreference['auto_confirm'];
}

if (initialState.rt_params) {
  initialState.rtParams = initialState.rt_params;
  delete initialState['rt_params'];
}

if (localStorage.authHeaders) {
  initialState.auth = initialState.auth || {};
  initialState.auth.token = JSON.parse(localStorage.getItem('authHeaders'));
}
else {
  initialState = {}
}


class App extends Component {
  render() {
    return (
      <Provider store = {createStore(rootReducer, initialState)}>
        <Routes />
      </Provider>
    );
  }
}

ReactDOM.render(<App />, document.querySelector("#clinsyte-app"));
