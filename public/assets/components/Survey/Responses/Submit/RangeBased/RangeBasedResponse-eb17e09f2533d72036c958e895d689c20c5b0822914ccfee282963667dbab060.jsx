class RangeBasedResponse extends Component {

  getResponse() {
    return this.refs.slider.getValue();
  }

  render() {
    var props = this.props;
    return (
      <SliderInput name = { props.id }
        min = { props.min }
        max = { props.max }
        ref = 'slider'
        rangeClassName = 'margin-right-10 margin-left-10'
        className = 'margin-top-40'
      />
    )
  }
}

RangeBasedResponse.propTypes = {
  id: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number
  ]).isRequired,
  max: PropTypes.number.isRequired,
  min: PropTypes.number.isRequired
}
