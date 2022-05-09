const EditTreatmentPlanAssociations = ({ association, onChange, onClear }) => {

  var handleChange = (event) => {
    onChange(event.currentTarget.value, event.currentTarget.checked);
  }

  return (
    <div>
      <p className = 'font-size-18 font-bold'>
        Therapy for
      </p>
      <label>
        <input type = 'checkbox'
          checked = { association === CONDITION_ASSOCIATION }
          onClick = { handleChange }
          value = { CONDITION_ASSOCIATION }
        />
        &nbsp;Condition
      </label>
      &nbsp;&nbsp;
      <label>
        <input type = 'checkbox'
          checked = { association === SYMPTOM_ASSOCIATION }
          onChange = { handleChange }
          value = { SYMPTOM_ASSOCIATION }
        />
        &nbsp;Symptom(s)
      </label>
    </div>
  );
}

EditTreatmentPlanAssociations.propTypes = {
  onChange: PropTypes.func.isRequired,
  association: PropTypes.string
}
