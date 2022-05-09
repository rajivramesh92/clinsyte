class UserForm extends Component {

  constructor(props) {
    super(props);

    var currentUserRole = this.getDefaultData().role;
    this.state = {
      selectedRole: ( currentUserRole ? currentUserRole.toLowerCase() : " " ),
      currentTimezone: this.getDefaultData().time_zone
    }
    this.onRoleChange = this.onRoleChange.bind(this);
    this.handleOnSubmit = this.handleOnSubmit.bind(this);
    this.handleChangInTimezone = this.handleChangInTimezone.bind(this);
    this.renderUUID = this.renderUUID.bind(this);
  }

  onRoleChange(value){
    this.setState({
      selectedRole: value
    });
  }

  getDefaultData(){
    return this.props.defaultData || { role: 'patient',
      birthdate: { month: 1, data: 1, year: 1990 }
    };
  }

  getFieldsForRole(){
    if(this.state.selectedRole === 'physician'){
      return (
        <div>
          <div className = 'form-group'>
            <label htmlFor = 'license-id'>License ID</label>
            <input type = 'text'
              className = 'form-control'
              id = 'license-id'
              ref = 'licenseId'
              defaultValue = { this.getDefaultData().license_id }
            />
          </div>
          <div className = 'form-group'>
            <label htmlFor = 'expiry'>Expiry</label>
            <DateSelect start = { new Date().getFullYear() }
              end = { 2100 }
              className = { 'col-md-4 date-select' }
              ref = 'expiry'
              defaultDate = { this.getDefaultData().expiry }
            />
          </div>
        </div>
      );
    }
  }

  getData() {
    var date = this.refs.birthdate.getDate();
    var birthdate = date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear();

    var passwordParams = {};
    if (this.props.formType === 'signup') {
      passwordParams.password = this.refs.password.value;
      passwordParams.password_confirmation = this.refs.passwordConfirmation.value;
    }
    else {
      passwordParams.current_password = this.refs.currentPassword.value;
    }

    var physicianParams = {};
    var phoneNumberWithCountryCode = this.refs.phoneNumberWithCountryCode.getValue();
    if(this.state.selectedRole == "physician"){
      var date = this.refs.expiry.getDate();
      physicianParams.expiry = date.getDate() + '/' + (date.getMonth() + 1) + '/' + date.getFullYear()
      physicianParams.license_id = this.refs.licenseId.value;
    }

    var userParams = {
      first_name: this.refs.firstName.value,
      last_name: this.refs.lastName.value,
      email: this.refs.email.value,
      gender: this.refs.gender.getValue(),
      ethnicity: this.refs.ethnicity.value,
      phone_number: phoneNumberWithCountryCode.phoneNumber,
      country_code: phoneNumberWithCountryCode.countryCode,
      role: this.refs.role.getValue(),
      preferred_device: this.refs.preferredDevice.getValue(),
      time_zone: this.state.currentTimezone,
      birthdate,
      ...passwordParams,
      ...physicianParams
    }

    return userParams;
  }

  hasAllFields(fields,data) {
    var missAnything = false;
    fields.forEach(field => {
      if (!data[field]) {
        missAnything = true;
      }
    })
    return !missAnything;
  }

  validateFormData(formData) {
    var errors = [];
    var physicianFields = [];
    if(this.state.selectedRole === 'physician') {
      physicianFields = ['license_id','expiry'];
    }
    var fieldsToBeChecked = ['role','email','first_name','last_name','ethnicity','birthdate','gender', 'phone_number', 'country_code', 'preferred_device', 'time_zone'].concat(physicianFields);
    if(this.hasAllFields(fieldsToBeChecked,formData)) {
      if(this.props.formType === 'profileEdit') {
          if (!formData.current_password) {
          errors.push('Please provide current password')
        }
      }
      else {
        if(formData.password && formData.password.length < 8) {
          errors.push('Password should be of minimum 8 characters');
        }
        else if(formData.password !== formData.password_confirmation) {
          errors.push('Password and password confirmation should be same')
        }
      }

      if (!validateEmail(formData.email)) {
        errors.push('Enter a valid email');
      }
    }
    else {
      errors.push('Please fill all the fields');
    }
    return errors;
  }

  handleOnSubmit(event) {
    event.preventDefault();
    var formData = this.getData();
    var errors = this.validateFormData(formData);
    if(errors.length == 0) {
      showToast('Please wait...','success');
      this.props.callback(formData);
    }
    else {
      showToast(errors,'error');
    }
  }

  handleChangInTimezone(currentTimezone) {
    this.setState({
      currentTimezone: currentTimezone.value
    });
  }

  componentDidMount() {
    this.refs.email.focus();
    if( this.props.getCurrentTimezone) {
      this.props.getCurrentTimezone(currentTimezone => this.setState( { currentTimezone } ));
    }
  }

  renderUUID(){
    return (
      <div className = 'form-group'>
        <label htmlFor = 'user-uuid'>ID</label>
        <input type = 'text'
          className = 'form-control'
          defaultValue = { this.getDefaultData().uuid }
          readOnly = 'readOnly'
        />
      </div>
    );
  }

  renderPhoneNumberVerification(){
    if ( this.props.formType != 'signup' && !this.getDefaultData().phone_number_verified ){
      return (
        <Link to='/verify/phone_number'>
          Verify phone number
        </Link>
      );
    }
  }

  render() {
    var genderOptions = [
      { key: 'male', value: 'male', display: 'Male'},
      { key: 'female', value: 'female', display: 'Female'}
    ];

    var roles = ['patient', 'physician', 'counselor', 'dispensary', 'support', 'caregiver'];
    var roleOptions = _.map(roles, role => {
      return {
        key: role,
        value: role,
        display: capitalize(role)
      };
    });

    var currentUserRole = this.getDefaultData().role;

    if ( isAdmin(this.getDefaultData())) {
      roleOptions = roleOptions.concat({ key: 'null', value: ' ', display: 'Admin' });
    }

    return (
      <div className = 'authform'>
        <form ref = 'signupForm' onSubmit = { this.handleOnSubmit }>
          <h4>{ this.props.heading }</h4>
          { this.props.formType === 'signup' ? null : this.renderUUID() }
          <div className = 'form-group'>
            <label htmlFor = 'user-role'>Role</label>
            <DropDown options = { roleOptions }
              disabled = { this.props.disableRole }
              className = { 'form-control' }
              ref = 'role'
              defaultVal = { this.state.selectedRole }
              onChange = { this.onRoleChange }
            />
          </div>
          <div className = 'form-group'>
            <label htmlFor = 'user-email'>Email</label>
            <input type = 'text'
              className = 'form-control'
              id = 'user-email'
              ref = 'email'
              defaultValue = { this.getDefaultData().email }
            />
          </div>
          { this.props.formType === 'signup' ? getPasswordField('password', 'password', 'Password') : null }
          { this.props.formType === 'signup' ? getPasswordField('password-confirmation', 'passwordConfirmation', 'Password Confirmation') : null }
          <div className = 'form-group'>
            <label htmlFor = 'user-first-name'>First name</label>
            <input type = 'text'
              className = 'form-control'
              id = 'user-first-name'
              ref = 'firstName'
              defaultValue = { this.getDefaultData().first_name }
            />
          </div>
          <div className='form-group'>
            <label htmlFor = 'user-last-name'>Last name</label>
            <input type = 'text'
              className = 'form-control'
              id = 'user-last-name'
              ref = 'lastName'
              defaultValue = { this.getDefaultData().last_name }
            />
          </div>
          <div className = 'form-group'>
            <label htmlFor = 'user-gender'>Gender</label>
            <DropDown options = { genderOptions }
              className = { 'form-control' }
              ref = 'gender'
              defaultVal = { this.getDefaultData().gender || 'male' }
            />
          </div>
          <div className = 'form-group'>
            <label htmlFor = 'user-ethnicity'>Ethnicity</label>
            <input type = 'text'
              className = 'form-control'
              id = 'user-ethnicity'
              ref = 'ethnicity'
              defaultValue = { this.getDefaultData().ethnicity }
            />
          </div>
          <div className = 'form-group clearfix'>
            <label htmlFor = 'user-birthdate'>Birthdate</label>
            <DateSelect start = { 1950 }
              end = { new Date().getFullYear() }
              className = { 'col-md-4 date-select' }
              ref = 'birthdate'
              defaultDate = { this.getDefaultData().birthdate }
            />
          </div>
          <div className = 'form-group'>
            <label htmlFor = 'user-phonenumber'>
              Phone number
            </label>
            <PhoneNumberInput countryCode = { this.getDefaultData().country_code }
              phoneNumber = { this.getDefaultData().phone_number }
              className = 'form-control'
              ref = 'phoneNumberWithCountryCode'
            />
            { this.renderPhoneNumberVerification() }
          </div>
          <div className = 'form-group'>
            <label htmlFor = 'prefered-device'>
              Device Preference
            </label>
            <Note header = 'Preferred Device'
              message = 'This option is just to know your device preferrence, it will not restrict you to any single device.'
              className = 'pull-right font-size-18'
            />
            <DropDown options = { getDeviceOptions() }
              className = 'form-control'
              ref = 'preferredDevice'
              defaultVal = { this.getDefaultData().preferred_device }
            />
          </div>
          <div className = 'form-group'>
            <label htmlFor = 'time-zone'>
              Timezone
            </label>
            <Select options = { getTimeZoneOptions() }
              ref = 'timezone'
              onChange = { this.handleChangInTimezone }
              value = { this.state.currentTimezone }
              clearable = { false }
            />
          </div>
          { this.getFieldsForRole() }
          { this.props.formType === 'profileEdit' ? getPasswordField('current-password', 'currentPassword', 'Current Password') : null }
          <div className = 'form-group'>
            <br />
            <input type = 'submit' defaultValue = { this.props.submitBtnValue || 'SUBMIT' } className = 'button right' />
          </div>
        </form>
      </div>
    )
  }
}

UserForm.propTypes = {
 submitBtnValue: PropTypes.string,
 formType: PropTypes.oneOf(['profileEdit', 'signup']).isRequired,
 defaultData: PropTypes.object,
 callback: PropTypes.func,
 disableRole: PropTypes.bool,
 heading: PropTypes.string
}


let getDeviceOptions = () => {
  var deviceOptions = [
    {
      displayName: 'Web Only',
      actualValue: 'web'
    },
    {
      displayName: 'Android Device(s)',
      actualValue: 'android'
    },
    {
      displayName: 'iOS Device(s)',
      actualValue: 'ios'
    },
    {
      displayName: 'Both Android and iOS Devices',
      actualValue: 'both_ios_and_android'
    }
  ];
  return _.map(deviceOptions, option => {
    return {
      value: option.actualValue,
      display: option.displayName,
      key: option.actualValue
    };
  });
}

let getTimeZoneOptions = () => {
  return _.flatten(_.map(TIMEZONES, zone => {
    return _.map(zone.utc, region => {
      return {
        value: region,
        label: getTimeZoneOffsetValue(zone.offset) + ' '  + region.replace('_', ' ') + ' - ' + zone.abbr
      }
    })
  }));
}

getTimeZoneOffsetValue = (offset) => {
  absOffset = Math.abs(offset);
  hours = padLeft(Math.floor(absOffset), '0', 2);
  min = padLeft((absOffset - hours) * 60, '0', 2);
  return (offset > 0 ? '+' : '-') + hours + ':' + min;
}
