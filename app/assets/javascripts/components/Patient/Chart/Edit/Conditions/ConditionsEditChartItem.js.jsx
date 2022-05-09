class ConditionsEditChartItem extends Component {

  constructor(props) {
    super(props);

    this.onAddCondition = this.onAddCondition.bind(this);
    this.suggestionSource = this.suggestionSource.bind(this);
    this.conditionSuggestionTemplate = this.conditionSuggestionTemplate.bind(this);
    this.conditionSuggestionSource = this.conditionSuggestionSource.bind(this);
    this.handleOnChangeInConditionName = this.handleOnChangeInConditionName.bind(this);
  }

  handleOnChange(conditionIndex, entity, entityId, newValue) {
    var conditions = [...this.props.conditions];
    if(entityId >= 0) {
      conditions[conditionIndex][entity][entityId] = newValue;
    }
    else {
      conditions[conditionIndex][entity] = newValue
    }
    this.setConditionState(conditions);
  }

  setConditionState(conditions) {
    this.props.onChange(conditions);
  }

  handleOnChangeInConditionName(conditionIndex) {
    var name = this.refs['conditionsName' + conditionIndex].getValue();
    this.handleOnChange(conditionIndex, 'name', undefined, name);
  }

  handleOnRemove(conditionIndex, entity, entityIndex) {
    var conditions = [...this.props.conditions];
    if(entity && entityIndex >= 0) {
      conditions[conditionIndex][entity][entityIndex]._destroy = true;
    }
    else {
      conditions[conditionIndex]._destroy = true;
    }
    this.setConditionState(conditions);
  }

  keyGenerator(element, index) {
    return index
  }

  suggestionSource(query, entity, syncCallback, asyncCallback) {
    this.props.searchChart(query, entity, this.props.token, asyncCallback)
  }

  renderConditionSymptoms(condition, conditionIndex) {
    return renderItems(condition.symptoms, (symptom, index) => {
      if(!symptom._destroy) {
        return (
          <EditSymptom symptom = { symptom }
            preFill = { true }
            key = { index }
            autoSuggestName = { 'symptom-' + index + '-' + conditionIndex }
            onRemoveClick = { this.handleOnRemove.bind(this, conditionIndex, 'symptoms', index) }
            onChange = { this.handleOnChange.bind(this, conditionIndex, 'symptoms',index ) }
            suggestionTemplate = { getAutoSuggestEngine }
            suggestionSource = { this.suggestionSource }
          />
        )
      }
    });
  }

  renderConditionMedications(condition, conditionIndex) {
    return renderItems(condition.medications, (medication, index) => {
      if(!medication._destroy) {
        return (
          <EditMedication preFill = { true }
            key = { index }
            autoSuggestNameName = { 'medication-' + index + '-' + conditionIndex }
            medication = { medication }
            onRemoveClick = { this.handleOnRemove.bind(this, conditionIndex, 'medications', index) }
            onChange = { this.handleOnChange.bind(this, conditionIndex, 'medications', index) }
            suggestionTemplate = { getAutoSuggestEngine }
            suggestionSource = { this.suggestionSource }
          />
        )
      }
    });
  }

  conditionSuggestionTemplate(condition) {
    return getAutoSuggestEngine(condition, 'name');
  }

  conditionSuggestionSource(query, syncCallback, asyncCallback) {
    this.suggestionSource(query, 'conditions', syncCallback, asyncCallback)
  }

  renderConditionsPresent() {
    return renderItems(this.props.conditions, (condition, index) => {
      if(condition._destroy) {
        return;
      }
      var d = new Date(Number(condition.diagnosis_date));
      var diag_date = { date: d.getDate(), month: d.getMonth() + 1, year: d.getFullYear() };
      return (
        <div preFill = { true }
          key = { index }
          onRemoveClick = { this.handleOnRemove.bind(this, index) }
          className = 'conditions'
          removeBtnValue = { condition.removeBtnValue }>
            <h5>Name</h5>
            <AutoSuggest source = { this.conditionSuggestionSource }
              className = 'form-control condition-name'
              name = { 'conditions' + '-' + index }
              ref = { 'conditionsName' + index }
              displayKey = { (suggestion) => { return suggestion.name } }
              suggestionTemplate = { this.conditionSuggestionTemplate }
              onSelectHandler = { this.handleOnChangeInConditionName.bind(this, index) }
              defaultValue = { condition.name }
              onChange = { this.handleOnChangeInConditionName.bind(this, index) }
            />
            <br/>
            <h5>Diagnosis Date</h5>
            <DateSelect defaultDate = { diag_date }
              className = 'date-select col-md-4 condition-diag-date'
              start = { 1950 }
              end = { new Date().getFullYear() }
              onChange = { this.handleOnChange.bind(this, index, 'diagnosis_date', undefined) }
            />
            <br/>
            <div className = 'margin-top-15 clearfix'>
              <h5>Symptoms</h5>
              <AddOne keyGen = { this.keyGenerator }
                addBtnValue = 'Add Symptom'
                addBtnClassName = 'btn btn-link add-btn-symptom'
                onAddClick = { this.onAddSymptom.bind(this, index) }>
                  { this.renderConditionSymptoms(condition, index) }
              </AddOne>
            </div>
            <br/>
            <div>
              <h5>Medications</h5>
              <AddOne keyGen = { this.keyGenerator }
                addBtnValue = 'Add Medication'
                addBtnClassName = 'btn btn-link add-btn-medication'
                onAddClick = { this.onAddMedication.bind(this, index)}>
                 { this.renderConditionMedications(condition, index) }
              </AddOne>
            </div>
            <input type = 'hidden'
              className = 'condition-id'
              defaultValue = { condition.id }
            />
        </div>
      )
    });
  }

  onAddMedication(conditionIndex, event) {
    event.preventDefault();
    var conditions = [...this.props.conditions];
    conditions[conditionIndex].medications.push({
      name: '',
      description: ''
    })
    this.setConditionState(conditions);
  }

  onAddSymptom(conditionIndex, event) {
    event.preventDefault();
    var conditions = [...this.props.conditions];
    conditions[conditionIndex].symptoms.push({
      name: ''
    })
    this.setConditionState(conditions);
  }

  onAddTherapy(conditionIndex, event) {
    event.preventDefault();
    var conditions = [...this.props.conditions];
    conditions[conditionIndex].therapies.push({
      id: null,
      strain_id: null
    })
    this.setConditionState(conditions)
  }

  onAddCondition(event) {
    var conditions = [...this.props.conditions];
    conditions.push({
      name: '',
      diagnosis_date: new Date().getTime(),
      symptoms: [],
      medications: [],
      therapies: [],
      removeBtnValue: 'Cancel'
    })
    this.setConditionState(conditions);
  }

  render() {
    return (
      <div>
        { getChartItemHeading('Conditions Reported') }
        <AddOne  keyGen = { this.keyGenerator }
          addBtnValue = 'add condition'
          removeBtnValue = 'Remove'
          addBtnClassName = 'btn btn-primary add-btn-condition margin-top-15'
          removeBtnClassName = 'btn btn-link chart-remove-btn pull-right margin-top-40'
          onAddClick = { this.onAddCondition }
          ref = 'conditions'>
          { this.renderConditionsPresent() }
        </AddOne>
      </div>
    )
  }
}
