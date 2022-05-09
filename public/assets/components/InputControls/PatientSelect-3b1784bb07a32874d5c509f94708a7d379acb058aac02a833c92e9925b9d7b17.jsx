const PatientSelect = ({ patients, onChange, className }) => {

  var getOptions = () => {

    var defaultOption = {
      value: 0,
      key: 'default',
      display: 'No patient selected'
    }

    return [defaultOption].concat(_.map(patients, patient => {
      return {
        key: patient.id,
        value: patient.id,
        display: patient.name
      }
    }));
  }

  var handleChange = (selectedPatient) => {
    onChange(Number(selectedPatient) != 0 ? selectedPatient : null);
  }

  return (
    <DropDown onChange = { handleChange }
      options = { getOptions() }
      className = { className }
      defaultVal = { 0 }
    />
  );

}

PatientSelect.propTypes = {
  patients: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  className: PropTypes.string
}
