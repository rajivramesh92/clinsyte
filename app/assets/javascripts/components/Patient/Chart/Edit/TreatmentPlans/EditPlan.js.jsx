class EditPlan extends Component {

  constructor(props) {
    super(props)
    this.state = {
      therapy: props.plan.therapy,
      ...this.getAssociationState(props.plan.associationEntities)
    }
    this.handleOnTherapySelect = this.handleOnTherapySelect.bind(this);
    this.handleOnAssoConditionChange = this.handleOnAssoConditionChange.bind(this);
    this.handleOnAssoSymptomChange = this.handleOnAssoSymptomChange.bind(this);
    this.handleChangeInAssociationType = this.handleChangeInAssociationType.bind(this);
    this.therapySuggestionSource = this.therapySuggestionSource.bind(this);
  }

  getAssociationState(associationEntities) {
    var firstEntity = _.first(associationEntities);
    var associationType = firstEntity ? firstEntity.entity_type : null;
    return {
      associationType,
      associationEntities
    }
  }

  getAssociationEntities() {
    return _.map(this.state.associationEntities, entity => {
      if (!_.isNull(entity.entity_object.id)) {
        return {
          ..._.omit(entity, 'entity_object'),
          entity_name: entity.entity_object.name
        };
      }
    });
  }

  getData() {
    return {
      id: this.props.plan.id,
      therapy: this.state.therapy,
      dosage: this.refs.dosage.getData(),
      frequencies: this.refs.frequencies.getData(),
      associationEntities: this.getAssociationEntities(),
      intakeTiming: this.refs.intakeTiming.getIntakeTiming()
    };
  }

  getConditionFromEntities() {
    let isConditionDestroyed = condition => {
      return condition._destroy == true;
    }
    var associatedCondition = _.find(_.filter(this.state.associationEntities, { entity_type: CONDITION_ASSOCIATION }), _.negate(isConditionDestroyed));
    return associatedCondition ? associatedCondition.entity_object : { id: null };
  }

  getSymptomsFromEntities() {
    var associatedSymptoms = _.filter(this.state.associationEntities, { entity_type: SYMPTOM_ASSOCIATION });
    return _.pluck(_.reject(associatedSymptoms, { _destroy: true }), 'entity_object');
  }

  getExistingRevisedEntities(selectedItems, entities) {
    return _.map(entities, entity => {
      let hasItemId = item => {
        return item.id == entity.entity_object.id;
      }

      return {
        ...entity,
        _destroy: !_.any(selectedItems, hasItemId)
      }
    });
  }

  getNewEntities(selectedItems, entities, revisedEntities, entityType) {
    return _.compact(_.map(selectedItems, item => {
      let itemExist = entity => {
        return entity.entity_object.id == item.id;
      }

      if (!_.any(revisedEntities, itemExist)) {
        return {
          entity_object: item,
          entity_type: entityType
        };
      }
    }));
  }

  getRevisedItems(selectedItems, forEntity) {
    let entitiesTouched = _.partition(this.state.associationEntities, { entity_type: forEntity });
    let existingRevisedEntities = this.getExistingRevisedEntities(selectedItems, _.first(entitiesTouched));
    let newEntities = this.getNewEntities(selectedItems, _.first(entitiesTouched), existingRevisedEntities, forEntity);
    return existingRevisedEntities.concat(newEntities, _.last(entitiesTouched));
  }

  handleChangeInAssociationType(associationType, checked) {
    var associationEntities = _.map(this.state.associationEntities, entity => {
      if (entity.entity_type == associationType) {
        return {
          ...entity,
          _destroy: !checked
        }
      }
      return {
        ...entity,
        _destroy: true
      };
    });

    this.setState({
      associationType: (checked ? associationType : null),
      associationEntities
    });
  }

  handleOnAssoConditionChange(associatedCondition) {
    associatedCondition = associatedCondition || { id: null }
    this.setState({
      associationEntities: this.getRevisedItems([associatedCondition], CONDITION_ASSOCIATION)
    });
  }

  handleOnAssoSymptomChange(associatedSymptoms) {
    this.setState({
      associationEntities: this.getRevisedItems(associatedSymptoms, SYMPTOM_ASSOCIATION)
    });
  }

  handleOnTherapySelect(therapy) {
    this.setState({
      therapy
    })
  }

  therapySuggestionSource(query, entity, syncCallback, asyncCallback) {
    this.props.searchChart(query, entity, this.props.token, asyncCallback)
  }

  renderAssociationsEdit() {
    var type = this.state.associationType;
    if (type === CONDITION_ASSOCIATION) {
      return (
        <EditTreatmentPlanCondition conditions = { this.props.conditions }
          onChange = { this.handleOnAssoConditionChange }
          selectedCondition = { this.getConditionFromEntities() }
        />
      );
    }
    else if (type === SYMPTOM_ASSOCIATION) {
      return (
        <EditTreatmentPlanSymptoms symptoms = { this.props.symptoms }
          onChange = { this.handleOnAssoSymptomChange }
          selectedSymptoms = { this.getSymptomsFromEntities() }
        />
      );
    }
  }

  render() {
    var plan = this.props.plan;
    return (
      <div>
        <div className = 'form-group'>
          <p className = 'font-bold font-size-18'>
            Therapy
            <span className = 'pull-right'>
              <IntakeTimingEdit intakeTiming = { plan.intakeTiming }
                ref = 'intakeTiming'
              />
            </span>
          </p>
          <EditTherapy therapy = { plan.therapy }
            autoSuggestName = { this.props.autoSuggestName }
            autoSuggestClassName = 'form-control'
            onSelect = { this.handleOnTherapySelect }
            suggestionTemplate = { getAutoSuggestEngine }
            suggestionSource = { this.therapySuggestionSource }
          />
        </div>
        <div className = 'form-group'>
          <EditTreatmentPlanAssociations association = { this.state.associationType }
            onChange = { this.handleChangeInAssociationType }
          />
        </div>
        <div className = 'form-group'>
          { this.renderAssociationsEdit() }
        </div>
        <div className = 'form-group'>
          <EditDosage dosage = { plan.dosage }
            ref = 'dosage'
          />
        </div>
        <div className = 'panel panel-default'>
          <div className = 'panel-body'>
            <EditDosageFrequency frequencies = { plan.frequencies }
              ref = 'frequencies'
            />
          </div>
        </div>
      </div>
    )
  }
}

EditPlan.propTyes = {
  plan: PropTypes.object.isRequired,
  conditions: PropTypes.array.isRequired,
  symptoms: PropTypes.array.isRequired,
  autoSuggestName: PropTypes.string.isRequired,
  searchChart: PropTypes.func.isRequired
}
