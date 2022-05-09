class TreatmentPlans extends Component {

  constructor(props) {
    super(props)
    this.renderPlan = this.renderPlan.bind(this);
  }

  renderPlan(plan, index) {
    editedPlan = {
      id: plan.id,
      therapy: plan.strain,
      dosage: {
        quantity: plan.dosage_quantity,
        unit: plan.dosage_unit
      },
      frequencies: plan.dosage_frequency,
      associationEntities: plan.association_entities,
      intakeTiming: plan.intake_timing
    }

    var getTitle = () => {
      return (
        <span>
          { editedPlan.therapy.name }&nbsp;&nbsp;
          <span className = { 'label pull-right label-' + intakeTimingColor[editedPlan.intakeTiming] } >
            { editedPlan.intakeTiming !== 'as_required' ? editedPlan.intakeTiming.toUpperCase() : 'Generic' }
          </span>
        </span>
      )
    }

    return (
      <ViewPlan key = { plan.id }
        Key = { plan.id }
        title = { getTitle() }
        plan = { editedPlan }
        showTakeDosage = { this.props.showTakeDosage }
        takeDosage = { this.props.takeDosage }
        planGroupId = { this.props.planGroupId }
      />
    )
  }

  renderPlans() {
    var plans = this.props.plans;
    if(_.isEmpty(plans)) {
      return (
        <center>
          <em className = 'text-muted text-center'>
            No therapies have been added in this treatment plan
          </em>
        </center>
      )
    }
    return (
      <Accordion id = 'treatment-plans'>
        { renderItems(plans, this.renderPlan) }
      </Accordion>
    )
  }


  render() {
    return (
      <div>
        { this.renderPlans() }
      </div>
    )
  }
}

TreatmentPlans.propTypes = {
  plans: PropTypes.array.isRequired,
  showTakeDosage: PropTypes.bool.isRequired,
  takeDosage: PropTypes.func.isRequired
}
