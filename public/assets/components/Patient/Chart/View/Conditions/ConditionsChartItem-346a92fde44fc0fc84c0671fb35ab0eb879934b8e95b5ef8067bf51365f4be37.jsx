class ConditionsChartItem extends Component {

  constructor(props) {
    super(props);
    this.getConditionMarkup = this.getConditionMarkup.bind(this);
    this.renderList = this.renderList.bind(this);
  }

  getConditionItems(condition) {
    return [
      { key: 1, heading: 'Diagnosis Date:', description: getDisplayDate(condition.diagnosis_date) },
      { key: 2, heading: 'Symptoms Reported:', description: condition.symptoms.map(symptom => {
        return {
          key: symptom.id,
          description: symptom.name
        }
      })},
      { key: 3, heading: 'Current Medications:', description: condition.medications.map(medication => {
        return {
          key: medication.id,
          description: medication.name + '(' + medication.description + ')'
        }
      })}
    ]
  }

  getConditionMarkup(condition) {
    return (
      <div title = { condition.name }
        key = { condition.id }
        Key = { condition.id }
        className = 'clearfix'>
        <HorizonDescList listItems = { this.getConditionItems(condition) }/>
      </div>
    )
  }

  renderList(){
    if( isEmpty(this.props.conditions) ){
      return (
        <div className='text-center text-muted'>
          <i>No conditions have been added</i>
        </div>
      );
    }
    else{
      return (
        <Accordion id = { 'conditions-reported' }>
          { renderItems(this.props.conditions, this.getConditionMarkup) }
        </Accordion>
      );
    }
  }

  render() {
    return (
      <div>
        { getChartItemHeading('Conditions Reported') }
        { this.renderList() }
      </div>
    )
  }
}
