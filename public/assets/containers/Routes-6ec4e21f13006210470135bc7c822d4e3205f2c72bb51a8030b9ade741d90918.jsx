var Component = React.Component;

//routing modules
var Router = ReactRouter.Router;
var Route = ReactRouter.Route;
var IndexRoute = ReactRouter.IndexRoute;
var browserHistory = History.createHistory();

class Routes extends Component {

  constructor(props) {
    super(props);

    this.redirectIfLoggedin = this.redirectIfLoggedin.bind(this);
    this.allowOnly = this.allowOnly.bind(this);
  }

  allowEveryone() {
    return this.allowOnly('patient', 'physician', 'caregiver', 'counselor', 'admin', 'support');
  }

  isUserLoggedIn() {
    return (this.props.authToken && this.props.user);
  }

  isUserValid(roles) {
    return _.any(roles, role => {
      return userContainsRole(this.props.user, role);
    });
  }

  allowOnly() {
    showMessage();
    var roles = arguments;

    return (nextState, replaceState, callback) => {

      if(!this.isUserLoggedIn()) {
        replaceState(null, '/sign_in');
      }
      else if (!this.isUserValid(roles)) {
        replaceState(null, '/user_not_allowed');
      }

      callback();
    }
  }

  redirectIfLoggedin(nextState, replaceState, callback) {
    var isLoggedIn = this.props.authToken && this.props.user
    showMessage();
    // ..code to change the state
    if (isLoggedIn) {
      replaceState(null,'/home');
    }
    callback();
  }

  render() {
    return (
        <Router history = { browserHistory } >
          <Route path = '/' component={Root}>
            <IndexRoute component = { Index }
              onEnter = { this.redirectIfLoggedin }
            />
            <Route path = 'sign_in'
              component = { SignIn }
              onEnter = { this.redirectIfLoggedin }
            />
            <Route path = 'sign_up'
              component = { SignUp }
              onEnter = { this.redirectIfLoggedin }
            />
            <Route path = 'forgot_password'
              component = { RecoverPassword }
              onEnter = { this.redirectIfLoggedin }
            />
            <Route path = 'validate_verification_code'
              component = { VerificationCodeValidator }
            />
            <Route path = 'reset_password'
              component = { ResetPassword }
              onEnter = { this.redirectIfLoggedin }
            />
            <Route path = '/home'
              component = { Home }
              onEnter = { this.allowEveryone() }
            />
            <Route path = '/my_calendar'
              component = { MyCalendar }
              onEnter = { this.allowOnly('physician', 'patient') }
            />
            <Route path = 'deactivate_account'
              component = { AccountDeactivator }
              onEnter = { this.allowEveryone() }
            />
            <Route path = 'resend_confirmation'
              component = { ResendConfirmation }
              onEnter = { this.redirectIfLoggedin }
            />
            <Route path = '/verify/phone_number'
              component = { PhoneNumberVerifier }
              onEnter = { this.allowEveryone() }
            />
            <Route path = 'users/:id'>
              <IndexRoute component = { UserProfile }
                onEnter = { this.allowEveryone() }
              />
              <Route path = 'chart'>
                <IndexRoute component = { PatientChart }
                  onEnter = { this.allowEveryone() }
                />
                <Route path = 'activities'
                  component = { PatientChartActivities }
                  onEnter = { this.allowEveryone() }
                />
              </Route>
              <Route path = 'calendar'
                component = { UserCalendar }
                onEnter = { this.allowOnly('patient') }
              />
            </Route>
            <Route path = 'careteam'>
              <IndexRoute component = { CareteamView }
                onEnter = { this.allowOnly('patient') }
              />
              <Route path = ':id/activities'
                component = { CareTeamActivities }
                onEnter = { this.allowOnly('patient') }
              />
            </Route>
            <Route path = 'profile'>
              <Route path = 'edit'
                component = { ProfileEdit }
                onEnter = { this.allowEveryone() }
              />
              <Route path = 'change_password'
                component = { ChangePassword }
                onEnter = { this.allowEveryone() }
              />
            </Route>
            <Route path='careteams'>
              <IndexRoute component={ CareteamListManager }
                onEnter={ this.allowOnly('physician', 'counselor', 'caregiver', 'support') }
              />
              <Route path = 'invite_patient'
                component = { PatientInviter }
                onEnter={ this.allowOnly('physician') }
              />
              <Route path = 'invites'
                component = { InvitationListManager }
                onEnter = { this.allowOnly('physician', 'counselor', 'caregiver', 'patient', 'support') }
              />
            </Route>
            <Route path = 'appointment'>
              <Route path = 'requests'
                component = { AppointmentListManager }
                onEnter = { this.allowOnly('physician') }
              />
            </Route>
            <Route path = 'notifications'
              component = { NotificationListManager }
              onEnter = { this.allowEveryone() }
            />
            <Route path = 'slots'
              component = { SlotManager }
              onEnter = { this.allowOnly('physician') }
            />
            <Route path = 'surveys'>
              <IndexRoute component = { SurveyManager }
                onEnter = { this.allowOnly('physician', 'admin', 'study_admin') }
              />
              <Route path = 'requests'
                component = { SurveyRequestsManager }
                onEnter = { this.allowOnly('patient') }
              />
              <Route path = 'create'
                component = { SurveyManager }
                onEnter = { this.allowOnly('physician', 'admin', 'study_admin') }
              />
              <Route path = 'send'>
                <IndexRoute component = { SendSurveyManager }
                  onEnter = { this.allowOnly('physician') }
                />
                <Route path = 'scheduler'
                  component = { ScheduleSurveySendManager }
                  onEnter = { this.allowOnly('physician') }
                />
              </Route>
              <Route path  = ':id'>
                <IndexRoute component = { SurveyManager }
                  onEnter = { this.allowOnly('physician', 'admin', 'study_admin') }
                />
                <Route path = 'response'>
                  <Route path = ':requestId'
                    component = { SurveyResponseManager }
                    onEnter = { this.allowOnly('physician', 'patient') }
                  />
                </Route>
                <Route path = 'edit'
                  component = { SurveyManager }
                  onEnter = { this.allowOnly('physician', 'admin', 'study_admin') }
                />
              </Route>
            </Route>
            <Route path = 'lists'>
              <IndexRoute component = { ListsViewManager }
                onEnter = { this.allowOnly('admin') }
              />
              <Route path = 'create'
                component = { CreateListManager }
                onEnter = { this.allowOnly('admin') }
              />
            </Route>
            <Route path = 'therapies'>
              <Route path = ':id'
                component = { TherapyProfileManager }
                onEnter = { this.allowEveryone() }
              />
            </Route>
            <Route path = '*'
              component = { FileNotFound }
            />
          </Route>
        </Router>
      )
  }
}

maptStateToProps = (state) => {
  return {
    authToken: state.auth.token,
    user: state.auth.user
  }
}

Routes = connect(maptStateToProps)(Routes);
