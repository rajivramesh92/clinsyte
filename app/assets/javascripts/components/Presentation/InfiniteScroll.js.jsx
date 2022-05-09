class InfiniteScroll extends Component {

  constructor(props) {
    super(props);
    var { complete, loading, page } = props;
    this.state = { complete, loading };
    this.page = page || 1;
  }

  componentWillReceiveProps(nextProps) {
    var { complete, loading, page, showNoMore } = nextProps;
    this.setState({ complete, loading, showNoMore });
    if (page) {
      this.page = page;
    }
  }

  componentDidMount() {
    var element = $('#' + this.props.name);
    $(element).scroll(() => {
      var { complete, loading } = this.state;
      if ($(element).scrollTop() + $(element).height() >= $(element).prop('scrollHeight') && !complete && !loading ) {
        this.props.loadMore(++this.page);
      }
    });
  }

  render() {
    var { name, height, width, className, preLoader, showNoMore } = this.props;
    var { loading, complete } = this.state;

    return (
      <div>
        <ScrollingList name = { name }
          height = { height }
          width = { width }
          className = { className }>
          { this.props.children }
          <div className = 'text-center'>
            { loading ? defaultPreLoader : '' }
            { complete && showNoMore ? defaultComplete : '' }
          </div>
        </ScrollingList>
      </div>
    )
  }
}

InfiniteScroll.propTypes = {
  loadMore: PropTypes.func.isRequired,
  name: PropTypes.string.isRequired,
  complete: PropTypes.bool,
  loading: PropTypes.bool,
  showNoMore: PropTypes.bool,
  preLoader: PropTypes.element,
  onComplete: PropTypes.element,
  height: PropTypes.number,
  width: PropTypes.number,
  page: PropTypes.number,
  className: PropTypes.string
}

InfiniteScroll.defaultProps = {
  complete: false,
  loading: false,
  showNoMore: true,
  preLoader: defaultPreLoader,
  onComplete: defaultComplete
}

const defaultPreLoader = <em>Loading...</em>

const defaultComplete = <em>No more items</em>;
