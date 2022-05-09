const Component = React.Component;
const Link = ReactRouter.Link;
var connect = ReactRedux.connect;
var PropTypes = React.PropTypes;

//APP NAME
const APP_NAME = "";
const APP_LOGO = "/assets/logo_icon-60f6b3e17ffff14a51fe2dc93bf79219ad96d4737260ed7d80bc4ca8141c1a5a.png";

//App constants
const INACTIVE = 'inactive';
const ACTIVE = 'active';

//auth constants
const LOGIN = 'LOGIN';
const LOGIN_SUCCESS = 'LOGIN_SUCCESS';
const LOGIN_FAILURE = 'LOGIN_FAILURE';

const SIGNUP = 'SIGNUP';
const SIGNUP_SUCCESS = 'SIGNUP_SUCCESS';
const SIGNUP_FAILURE = 'SIGNUP_FAILURE';

const SET_AUTH_HEADERS = 'SET_AUTH_HEADERS';

//welcome constants
const SET_WELCOME = 'SET_WELCOME';
const UNSET_WELCOME = 'UNSET_WELCOME';

//user data constants
const SET_USER = 'SET_USER';

// physician constants
const SET_CURRENT_PHYSICIAN = 'SET_CURRENT_PHYSICIAN';
const CHANGE_PRIMARY_PHYSICIAN = 'CHANGE_PRIMARY_PHYSICIAN';

const SET_SIGNED_IN_FIRST_TIME = 'SET_SIGNED_IN_FIRST_TIME';
7
const PHONE_NUMBER_VERIFIED = 'PHONE_NUMBER_VERIFIED';

//log out
const LOGOUT = 'LOGOUT';

//qr code
const SET_QR = 'SET_QR';
const UNSET_QR = 'UNSET_QR';

//notifications
const LOAD_NOTIFICATIONS = 'LOAD_NOTIFICATIONS';
const MARK_NOTIFICATION_AS_READ = 'MARK_NOTIFICATION_AS_READ';
const MARK_ALL_NOTIFICATIONS_READ = 'MARK_ALL_NOTIFICATIONS_READ';
const NOTIFICATIONS_ERROR = 'NOTIFICATIONS_ERROR';
const REMOVE_NOTIFICATION = 'REMOVE_NOTIFICATION';

// Careteams
const LOAD_CARETEAMS = 'LOAD_CARETEAMS';
const REMOVE_CARETEAM = 'REMOVE_CARETEAM';
const ADD_CARETEAM = 'ADD_CARETEAM';

const LOAD_CARETEAM = 'LOAD_CARETEAM';
const ADD_CARETEAM_MEMBER = 'ADD_CARETEAM_MEMBER';
const REMOVE_CARETEAM_MEMBER = 'REMOVE_CARETEAM_MEMBER';

// invitations
const LOAD_CARETEAM_INVITES = 'LOAD_CARETEAM_INVITES';
const REMOVE_CARETEAM_INVITE = 'REMOVE_CARETEAM_INVITE';

//careteamRequests
const SET_CARETEAM_REQUESTS = 'SET_CARETEAM_REQUESTS';
const ADD_CARETEAM_REQUEST = 'ADD_CARETEAM_REQUEST';
const REMOVE_CARETEAM_REQUEST = 'REMOVE_CARETEAM_REQUEST';
const REMOVE_CARETEAM_REQUEST_USING_CARETEAMID = 'REMOVE_CARETEAM_REQUEST_USING_CARETEAMID';
//appointment preferences
const SET_AUTO_CONFIRM = 'SET_AUTO_CONFIRM';
const UNSET_AUTO_CONFIRM = 'UNSET_AUTO_CONFIRM';

//surveys
const SET_SURVEYS = 'SET_SURVEYS';
const UPDATE_SURVEYS = 'UPDATE_SURVEYS';
const START_RESPONSE = 'START_RESPONSE';
const ADD_SURVEY = 'ADD_SURVEY';
const APPEND_SURVEYS = 'APPEND_SURVEYS';
const REMOVE_TPD_SURVEYS = 'REMOVE_TPD_SURVEYS';

//lists constants
const SET_LISTS = 'SET_LISTS';
const UNSET_LISTS = 'UNSET_LISTS';

const SLOT_TIME = 1800;
const SLOT_TIME_MESSAGE = 'Free time for Appointment'
const SLOT_BUSY_MESSAGE = 'Slot not available for booking'

//error messages
const SOMETHINGWRONG = 'Something went wrong please try again';

//survey constants
const DAY_SCHEDULER_OPTIONS = ['daily', 'weekly', 'monthly', 'Speciy Number Of Days'];

//date format constants
REQUEST_DATE_FORMAT = 'DD/MM/YYYY';

//chart constants
const DOSAGE_UNITS = ['mg', 'ml', 'spoons', 'tablets'];

//alerts
const SHOW_MEDICINE_ALERT = 'SHOW_MEDICINE_ALERT';
const HIDE_MEDICINE_ALERT = 'HIDE_MEDICINE_ALERT';

//rt_params constants
const SET_RTPARAMS = 'SET_RTPARAMS';
const UNSET_RTPARAMS = 'UNSET_RTPARAMS';
