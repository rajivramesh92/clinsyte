const SurveyLink = ({ survey }) => (
  <span className = 'text-capitalize'>
    { renderSurveyName(survey) }&nbsp;
    { renderTPDLabel(survey.treatment_plan_dependent) }
  </span>
)

SurveyLink.propTypes = {
  survey: PropTypes.object.isRequired
}

const renderTPDLabel = (treatmentPlanDependent) => {
  if (treatmentPlanDependent) {
    return (
      <label className = 'label label-success'
        title = 'Treatment Plan Dependent'>
        TPD
      </label>
    );
  }
}

const renderSurveyName = (survey) => {
  if (survey.status !== 'inactive') {
    return (
      <Link to = { '/surveys/' + survey.id }>
        { survey.name }
      </Link>
    );
  }
  else {
    return survey.name;
  }
}
