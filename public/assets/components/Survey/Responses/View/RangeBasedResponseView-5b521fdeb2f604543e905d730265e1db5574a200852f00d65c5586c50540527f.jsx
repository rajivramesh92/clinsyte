const RangeBasedResponseView = ({ response, min, max, id }) => (
  <SliderInput name = { id }
    min = { min }
    max = { max }
    value = { response }
    disabled = { true }
    rangeClassName = 'margin-right-10 margin-left-10'
    className = 'margin-top-40 pull-left'
  />
)

RangeBasedResponseView.propTypes = {
  response: PropTypes.number.isRequired,
  min: PropTypes.number.isRequired,
  max: PropTypes.number.isRequired,
  id: PropTypes.string.isRequired
}
