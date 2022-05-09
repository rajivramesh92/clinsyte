class PhoneNumberInput extends Component {

  getValue() {
    return {
      countryCode: this.refs.countryCode.value,
      phoneNumber: this.refs.phoneNumber.value
    }
  }

  handlePhoneKeyPress(event) {
    if(event.charCode < 48 || event.charCode > 57 ){
      event.preventDefault();
    }
  }

  render() {
    return (
      <div>
        <div className = 'vertically-centered phone-inp-cc'>
          <div className='input-group full-width'>
            <span className = 'input-group-addon left-padding-0 font-size-15'>
              +
            </span>
            <input type = 'text'
              maxLength = '5'
              className = 'form-control'
              ref = 'countryCode'
              onKeyPress = { this.handlePhoneKeyPress }
              defaultValue = { this.props.countryCode }
            />
          </div>
        </div>
        <div className = 'vertically-centered phone-inp-no'>
          <div className = 'input-group full-width'>
            <span className='input-group-addon font-size-15'>
             -
            </span>
            <input type = 'text'
              className = 'form-control'
              maxLength = '10'
              ref = 'phoneNumber'
              onKeyPress = { this.handlePhoneKeyPress }
              defaultValue = { this.props.phoneNumber }
            />
          </div>
        </div>
      </div>
    );
  }
}

// Property types for PhoneNumberInput Component
PhoneNumberInput.propTypes = {
  className: PropTypes.string,
  countryCode: PropTypes.string,
  phoneNumber: PropTypes.string
}
