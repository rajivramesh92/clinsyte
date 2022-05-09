const EditTreatmentPlanCondition = ({ conditions, selectedCondition, onChange }) => {

  var nullCondition = {
    value: null,
    display: 'None',
    key: 'none'
  };

  var getConditionOptions = () => {
    return [nullCondition].concat(_.map(conditions, condition => {
      var value = display = key = condition.name
      return { value, display, key };
    }));
  };

  var handleChange = (name) => {
    onChange(_.findWhere(conditions, { name }) || null);
  };

  return (
    <div>
      <p className = 'font-size-18 font-bold'>
        Associated Condition
      </p>
      <DropDown options = { getConditionOptions() }
        className = 'form-control'
        onChange = { handleChange }
        defaultVal = { selectedCondition.name }
      />
    </div>
  )
}

EditTreatmentPlanCondition.propTypes = {
  conditions: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  selectedCondition: PropTypes.object
}
