class Physicians extends Component {

  constructor(props) {
    super(props);
    this.physicians = [];
  }

  componentWillUpdate(nextProps, nextState) {
    var physicians = nextProps.data;
    var selectButton = false;

    if(this.props.selectButton) {
      selectButton = true;
    }

    this.physicians = physicians.map(physician => {
      return {
        key: physician.uuid,
        cells: [
          { key: 0, value: physician.first_name + ' ' + physician.last_name },
          { key: 1, value: physician.gender },
          { key: 2, value: physician.ethnicity },
          { key: 3, value: physician.email },
          selectButton ? { key: 4, value: <LinkButton to = '#' val = { 'SELECT' } /> } : undefined
        ]
      }
    });
  }

  render() {
    return (
        <ListView
          rows = { this.physicians }
          class = { 'table table-hover' }
        />
      )
  }
}
