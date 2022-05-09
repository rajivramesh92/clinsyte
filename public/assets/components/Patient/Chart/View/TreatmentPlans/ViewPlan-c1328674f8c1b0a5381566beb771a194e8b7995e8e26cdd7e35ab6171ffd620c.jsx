class ViewPlan extends Component {

  constructor(props) {
    super(props)

    this.handleTakeDosageClick = this.handleTakeDosageClick.bind(this);
    this.renderTakeDosageButton = this.renderTakeDosageButton.bind(this);
  }

  getAssociateConditionMarkUp(name) {
    return (
      <p>
        <em>
          For Condition:&nbsp;
        </em>
        <span className = 'font-bold'>
          { name }
        </span>
      </p>
    );
  }

  getAssociatedSymptomsMarkUp(symptoms) {
    var renderSymptomAssoc = symptom => {
      return (
        <li key = { symptom.id }>
          { symptom.name }
        </li>
      );
    }

    return (
      <div>
        <em>
          For Symptoms
        </em>:
        <ul>
          { renderItems(symptoms, renderSymptomAssoc) }
        </ul>
      </div>
    );
  }

  renderAssociations(associationEntities) {
    if(!_.isEmpty(associationEntities)) {
      var firstEntity = _.first(associationEntities);
      if (firstEntity.entity_type === CONDITION_ASSOCIATION) {
        return this.getAssociateConditionMarkUp(firstEntity.entity_object.name)
      }
      else if (firstEntity.entity_type === SYMPTOM_ASSOCIATION) {
        return this.getAssociatedSymptomsMarkUp(_.pluck(associationEntities, 'entity_object'));
      }
    }
  }

  renderFrequency(frequency) {
    return (
      <li key = { frequency.id} >
        { capitalize(frequency.name.replace(/\bn\b/,frequency.value)) }
      </li>
    )
  }

  renderFrequencies() {
    var frequencies = this.props.plan.frequencies;
    if(_.isEmpty(frequencies)) {
      return <em className = 'small text-muted'>No Specifications</em>
    }
    else {
      return renderItems(frequencies, this.renderFrequency)
    }
  }

  renderTakeDosageButton() {
    if (!this.props.showTakeDosage) {
      return;
    }
    return (
    <button className = 'btn btn-success take-dosage-btn pull-right'
      onClick = { this.handleTakeDosageClick }>
      Take Dosage
    </button>
    )
  }

  handleTakeDosageClick(event) {
    event.preventDefault();
    this.props.takeDosage(this.props.planGroupId, this.props.plan.id);
  }

  render() {
    var plan = this.props.plan
    return (
      <div className = 'clearfix margin-left-20'>
        { this.renderTakeDosageButton() }
        <p className = 'font-size-14'>
          <em>Dosage:&nbsp;</em>
          <span className = 'font-bold'>
            { plan.dosage.quantity + ' ' + plan.dosage.unit }
          </span>
        </p>
        { this.renderAssociations(plan.associationEntities) }
        <div className = 'font-size-14'>
          <em>Times/Frequency</em>
          <ul>
            { this.renderFrequencies() }
          </ul>
        </div>
      </div>
    )
  }
}

ViewPlan.propTypes = {
  plan: PropTypes.object.isRequired,
  showTakeDosage: PropTypes.bool.isRequired,
  takeDosage: PropTypes.func.isRequired
}
