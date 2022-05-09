class TreatmentPlansEdit extends Component {

  constructor(props) {
    super(props);
    this.state = {
      plans: this.props.plans || []
    }
    this.onAddTreatment = this.onAddTreatment.bind(this);
    this.renderPlan = this.renderPlan.bind(this);
  }

  getData() {
    var editPlans = this.refs
    var updatedPlans = _.map(editPlans, editPlan => {
      planData = editPlan.getData()
      return {
        id: planData.id,
        strain_id: planData.therapy.strain_id,
        dosage_quantity: planData.dosage.quantity,
        dosage_unit: planData.dosage.unit,
        dosage_frequency: planData.frequencies,
        association_entities: planData.associationEntities,
        intake_timing: planData.intakeTiming
      }
    })
    return updatedPlans.concat(_.filter(_.map([...this.state.plans], plan => _.pick(plan, 'id', '_destroy')), { _destroy: true }));
  }

  renderPlan(plan, index) {
    if(plan._destroy) {
      return;
    }
    var editedPlan = {
      id: plan.id,
      therapy: {
        strain_id: plan.strain.id,
        name: plan.strain.name
      },
      dosage: {
        quantity: plan.dosage_quantity,
        unit: plan.dosage_unit
      },
      frequencies: plan.dosage_frequency,
      associationEntities: plan.association_entities,
      intakeTiming: plan.intake_timing
    }
    return (
      <div preFill = { true }
      key = { index }
      onRemoveClick = { this.handleOnRemove.bind(this, index) }
      className = 'margin-top-40 plan-edit'
      removeBtnValue = { plan.removeBtnValue }>
      <EditPlan plan = { editedPlan }
        conditions = { this.props.conditions }
        symptoms = { this.props.symptoms }
        autoSuggestName = { 'therapy-plan-' + this.props.planGroupIndex + index }
        searchChart = { this.props.searchChart }
        ref = { 'plan-' + index }
        token = { this.props.token }
      />
      </div>
    )
  }

  renderTreatmentPlansPresent() {
    return renderItems(this.state.plans, this.renderPlan)
  }

  handleOnRemove(index) {
    var plans = [...this.state.plans];
    plans[index]._destroy = true;
    this.setState({
      plans
    })
  }

  onAddTreatment(event) {
    event.preventDefault();
    var plans = [...this.state.plans];
    plans.push({
      ...BLANK_PLAN_THERAPY
    });
    this.setState({
      plans
    })
  }

  render() {
    return (
      <div>
        <AddOne addBtnValue = 'Add Therapy'
          removeBtnValue = 'Remove'
          addBtnClassName = 'btn btn-link add-btn-therapy margin-top-15'
          removeBtnClassName = 'btn btn-link pull-right chart-remove-btn margin-top-40'
          onAddClick = { this.onAddTreatment }>
          { this.renderTreatmentPlansPresent() }
        </AddOne>
      </div>
    )
  }
}

TreatmentPlansEdit.propTypes = {
  plans: PropTypes.array.isRequired,
  searchChart: PropTypes.func.isRequired,
  token: PropTypes.object.isRequired,
  conditions: PropTypes.array.isRequired,
  symptoms: PropTypes.array.isRequired,
  planGroupIndex: PropTypes.number.isRequired
}
