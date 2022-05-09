class ProfileEditForm extends Component {

  constructor(props) {
    super(props);

    var user = this.props.user;
    var birthdate = new Date(Number(user.birthdate));
    user.birthdate = {
      date: birthdate.getDate(),
      month: birthdate.getMonth() + 1,
      year: birthdate.getFullYear()
    }
    this.state = {
      user,
      token: this.props.token
    }

    this.callback = this.callback.bind(this);
  }

  callback(formData) {
    var user = this.state.user;
    var token = this.state.token
    this.props.updateProfile(formData, user.id, token)
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      user: nextProps.user
    })
  }

  render() {
    return (
      <div className="wrapper">
        <UserForm heading = { 'Edit Profile' }
          callback = { this.callback }
          disableRole = { true }
          defaultData = { this.state.user }
          submitBtnValue = { 'Update' }
          formType = { 'profileEdit' }
          ref = 'userForm'
        />
      </div>
    )
  }
}
