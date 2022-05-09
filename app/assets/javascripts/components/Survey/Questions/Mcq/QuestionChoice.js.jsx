/**
 * renders component for creating choice with a disabled radio button
 * @param  {string} options.option value of choice
 * @param  {string} options.className   CSS classes for input control
 * @param  {function} options.onBlur      event handler for onBlur event on input control
 * @return {React Component}
 */
const QuestionChoice = ({ option, onBlur, textClassName, optionClassName }) => {

  const handleOnBlur = (event) => {
    onBlur(event.currentTarget.value);
  }

  return(
    <span>
      <input type = 'radio'
        disabled = { true }
        checked = { true }
        className = { optionClassName }
      />
      <input type = 'text'
        defaultValue = { option }
        onBlur = { handleOnBlur }
        className = { textClassName }
      />
    </span>
  )
}

QuestionChoice.propTypes = {
  option: PropTypes.string.isRequired,
  onBlur: PropTypes.func.isRequired,
  textClassName: PropTypes.string,
  optionClassName: PropTypes.string
}
