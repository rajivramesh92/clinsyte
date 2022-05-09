class QuestionSpecifications extends Component {

  getAttributes() {
    var specifications = this.refs.specifications;

    if (specifications) {
      return specifications.getAttributes();
    }
    else {
      return null;
    }
  }

  render() {
    switch(this.props.category) {

      case MULTIPLE_CHOICE:
        return (
          <div>
            <label className = 'blue'>
              Enter Choices
            </label>
            <QuestionChoiceList ref = 'specifications' />
          </div>
        );

      case RANGE_BASED:
        return <RangeBasedOptions ref = 'specifications' />;

      case LIST_BASED:
        return (
            <ListBasedOptions ref = 'specifications'
              lists = { this.props.lists }
            />
          );

      default:
        return <em className = 'small text-muted'>No Spefications</em>;
    }
  }
}

QuestionSpecifications.propTypes = {
  category: PropTypes.string.isRequired
}
