class CreateListOptions extends Component {

  constructor(props) {
    super(props);

    this.state = {
      options: this.props.options || []
    }

    this.addClassName = this.getAddClassName(props.options);

    this.handleOnAddClick = this.handleOnAddClick.bind(this);
    this.handleChangeInOption = this.handleChangeInOption.bind(this);
    this.handleKeyDown = this.handleKeyDown.bind(this);
    this.renderOption = this.renderOption.bind(this);
  }

  getOptions() {
    return _.reject([...this.state.options], { id: null, name: '' });
  }

  componentWillUpdate(nextProps, nextState) {
    this.addClassName = this.getAddClassName(nextState.options);
  }

  componentDidUpdate(prevProps, prevState) {
    if(prevState.options.length < this.state.options.length) {
      _.last(_.map(this.refs)).focus();
    }
  }

  getAddClassName(options) {
    return _.isEmpty(options) ? 'text-center font-size-18' : 'text-right font-size-11';
  }

  setOptions(options, concat = true) {
    var options = !concat ? options : options.concat(_.filter([...this.state.options], { status: INACTIVE }));
    this.setState({
      options
    });
  }

  getActiveOptions() {
    return _.reject([...this.state.options], { status: INACTIVE });
  }

  handleKeyDown(optionIndex) {
    return (event) => {
      var options = this.getActiveOptions();
      isLast = (optionIndex == _.findLastIndex(this.getActiveOptions()))
      if (event.keyCode == 13 && isLast) {
        this.handleOnAddClick();
      }
    }
  }

  handleOnRemoveClick(optionIndex) {
    return (event) => {
      event.preventDefault();
      var options = _.map(this.getActiveOptions(), (option, index) => {
        if(optionIndex === index) {
          if(option.id) {
            return {
              ...option,
              status: INACTIVE
            };
          }
          else {
            return null;
          }
        }
        return option;
      });

      this.setOptions(_.reject(options, _.isNull));
    }
  }

  handleChangeInOption(optionIndex) {
    return (event) => {
      var options = this.getActiveOptions();
      options[optionIndex].name = this.refs['option' + optionIndex].value;

      this.setOptions(options);
    }
  }

  handleOnAddClick(event) {
    var options = [...this.state.options].concat(_.create({},newOption));
    this.setOptions(options, false);
  }

  renderOption(option, index) {
    return (
      <div className = 'list-group-item no-padding'
        key = { option.name + index }>
        <span className = 'full-width no-margin'>
          <span className = 'pull-right'>
            <span onClick = { this.handleOnRemoveClick(index) }
              title = 'Remove'
              className = 'cursor-pointer red'>
              <Icon icon = { DELETE_ICON }/>
            </span>
          </span>
          <label className = 'blue'>
            { index + 1 }.
          </label>
        </span>
        <input className = 'form-control'
          ref = { 'option' + index }
          defaultValue = { option.name }
          onBlur = { this.handleChangeInOption(index) }
          onKeyDown = { this.handleKeyDown(index) }
        />
      </div>
    );
  }

  render() {
    return (
      <div>
        <h5 className = 'text-center'>
          List Options
        </h5>
        <div className = 'list-group'>
          { renderItems(this.getActiveOptions(), this.renderOption) }
        </div>
        <div className = 'margin-top-15'>
          <div className = { this.addClassName }>
            <button className = { 'btn-link link-btn blue' }
              onClick = { this.handleOnAddClick }>
              <Icon icon = { ADD_ICON } />&nbsp;Add Option
            </button>
          </div>
        </div>
      </div>
    )
  }
}

CreateListOptions.propTypes = {
  options: PropTypes.array
}

var newOption = {
  name: '',
  id: null
}
