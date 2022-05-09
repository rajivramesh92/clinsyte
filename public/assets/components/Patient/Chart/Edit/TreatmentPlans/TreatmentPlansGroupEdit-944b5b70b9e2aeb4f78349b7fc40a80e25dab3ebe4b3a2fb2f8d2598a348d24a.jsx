class TreatmentPlansGroupEdit extends Component {

  constructor(props) {
    super(props);
    this.state = {
      planGroups: this.props.planGroups || []
    }
    this.onAddTreatmentGroup = this.onAddTreatmentGroup.bind(this);
    this.renderPlanGroup = this.renderPlanGroup.bind(this);
  }

  getData() {
    var checkForTreatmentPlansEdit = (ref, refKey) => refKey.indexOf('treatmentPlansEdit') > -1;
    var planGroupsEdited = _.map(_.pick(this.refs, checkForTreatmentPlansEdit), (ref, refKey) => {
      var index = _.last(refKey);
      var id = this.state.planGroups[index].id;
      var title = this.refs['title' + index].value;
      var therapies = ref.getData();
      return { id, title, therapies };
    });
    return planGroupsEdited.concat(_.map(_.filter(this.state.planGroups, { _destroy: true }), group => _.pick(group, 'id', '_destroy')));
  }

  handleOnRemove(index) {
    var planGroups = [...this.state.planGroups];
    planGroups[index]._destroy = true;
    this.setState({
      planGroups
    });
  }

  onAddTreatmentGroup(event) {
    event.preventDefault();
    var planGroups = [...this.state.planGroups];
    planGroups.push({
      title: '',
      therapies: [{
        ...BLANK_PLAN_THERAPY
      }]
    });
    this.setState({
      planGroups
    });
  }

  renderPlanGroup(planGroup, index) {
    if (planGroup._destroy) {
      return;
    }
    return (
      <div preFill = { true }
        key = { index }
        onRemoveClick = { this.handleOnRemove.bind(this, index) }
        className = 'margin-top-40'
        removeBtnValue = 'Remove Plan'>
        <div className = 'form-group'>
          <p className = 'font-bold font-size-18'>
            Title
          </p>
          <input type = 'text'
            className = 'form-control'
            ref = { 'title' + index }
            placeholder = 'Title for treatment plan'
            defaultValue = { planGroup.title }
          />
        </div>
        <TreatmentPlansEdit plans = { planGroup.therapies || [] }
          ref = { 'treatmentPlansEdit' + index }
          conditions = { this.props.conditions }
          symptoms = { this.props.symptoms }
          token = { this.props.token }
          onChange = { this.props.onChange }
          searchChart = { this.props.searchChart }
          planGroupIndex = { index }
        />
      </div>
    )
  }

  renderTreatmentPlansGroupPresent() {
    return renderItems(this.state.planGroups, this.renderPlanGroup)
  }

  render() {
    return (
      <div>
        <AddOne addBtnValue = 'Add Plan'
          removeBtnValue = 'Remove'
          addBtnClassName = 'btn btn-primary margin-top-15'
          removeBtnClassName = 'btn btn-link pull-right chart-remove-btn'
          onAddClick = { this.onAddTreatmentGroup }>
          { this.renderTreatmentPlansGroupPresent() }
        </AddOne>
      </div>
    )
  }
}

TreatmentPlansGroupEdit.propTypes = {
  planGroups: PropTypes.array.isRequired,
  searchChart: PropTypes.func.isRequired,
  token: PropTypes.object.isRequired,
  conditions: PropTypes.array.isRequired,
  symptoms: PropTypes.array.isRequired
}
