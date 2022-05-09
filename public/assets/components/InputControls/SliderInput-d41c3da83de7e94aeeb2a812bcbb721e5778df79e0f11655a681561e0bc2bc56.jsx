class SliderInput extends Component {

  constructor(props) {
    super(props);
    this.id = 'slider' + this.props.name
  }

  getValue() {
    return this.slider.getValue();
  }

  componentDidMount() {
    sliderId = '#' + this.id;
    this.slider = new Slider(sliderId, {});
  }

  render() {
    var props = this.props
    return (
      <div className = { props.className }>
        <span className = { props.rangeClassName }>
          { props.min }
        </span>
        <input id = { this.id }
          data-slider-min = { props.min }
          data-slider-max = { props.max }
          data-slider-step = '1'
          data-slider-value = { props.value || props.min }
          data-slider-enabled = { !props.disabled }
          data-slider-handle = { props.customHandler ? 'custom' : 'round' }
          data-slider-tooltip = { props.customHandler ? 'hide': 'always' }
        />
        <span className = { props.rangeClassName }>
          { props.max }
        </span>
      </div>

    )
  }
}

SliderInput.propTypes = {
  name: PropTypes.string.isRequired,
  min: PropTypes.oneOfType([PropTypes.number, PropTypes.string]).isRequired,
  max: PropTypes.oneOfType([PropTypes.number, PropTypes.string]).isRequired,
  className: PropTypes.string,
  rangeClassName: PropTypes.string,
  customHandler: PropTypes.bool,
  value: PropTypes.number,
  disabled: PropTypes.bool
}
