class ListViewWithItems extends Component {

  constructor(props){
    super(props);

    this.modes = [HIDE_OPTIONS, VIEW_OPTIONS];

    this.state = {
      mode: _.first(this.modes)
    };

    this.selector = '#' + this.props.list.id + '-list-wrapper';

    this.handleModeChange = this.handleModeChange.bind(this);
  }

  componentDidMount() {
    $(this.selector).hide();
  }

  componentDidUpdate() {
    var mode = this.state.mode;

    if(mode === HIDE_OPTIONS) {
      $(this.selector).slideUp();
    }
    else {
      $(this.selector).slideDown();
    }
  }

  handleModeChange(event) {
    this.setState({
      mode: toggleValue(this.modes, this.state.mode)
    });
  }

  renderOption(option, index) {
    return (
      <div key = { option.id }>
        <div className = 'display-table-cell blue'>
          { index + 1}.&nbsp;
        </div>
        <div className = 'vertically-centered'>
          { option.name }
        </div>
      </div>
    )
  }

  renderOptions() {
    var mode = this.state.mode;
    var id = this.props.list.id
    var options = this.props.list.options;

    return (
      <div id = { id + '-list-wrapper' }>
        <span className = 'font-bold'>
          Options
        </span>
        <ScrollingList name = { id + 'options' }
          height = { 150 }
          className = 'margin-left-20'>
          { renderItems(options, this.renderOption) }
        </ScrollingList>
      </div>
    );
  }

  render() {
    return (
      <div className = 'full-width'>
        <button className = 'btn-link link-btn blue'
          onClick = { this.handleModeChange }>
            { this.props.list.name }
          </button>
          { this.renderOptions() }
      </div>
    );
  }
}

ListViewWithItems.propTypes = {
  list: PropTypes.object.isRequired
}

const HIDE_OPTIONS = 'hide';
const VIEW_OPTIONS = 'view';
