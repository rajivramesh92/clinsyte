const EditTreatmentPlanSymptoms = ({ symptoms, selectedSymptoms, onChange }) => {

  var getSymptomOptions = (symptoms) => {
    return _.map(symptoms, symptom => {
      return {
        value: symptom.id,
        label: symptom.name
      };
    });
  };

  var handleChange = (symptoms) => {
    var newSymptoms = _.map(symptoms, symptom => {
      return {
        id: symptom.value,
        name: symptom.label
      };
    });
    onChange(newSymptoms);
  }

  return (
    <div>
      <p className = 'font-size-18 font-bold'>
        Associated Symptom(s)
      </p>
      <Select name = 'associatedSymptoms'
        options = { getSymptomOptions(symptoms) }
        value = { getSymptomOptions(selectedSymptoms) }
        multi = { true }
        placeholder = 'No symptoms selected'
        onChange = { handleChange }
      />
    </div>
  )
}

EditTreatmentPlanSymptoms.propTypes = {
  symptoms: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  selectedSymptoms: PropTypes.array
}
