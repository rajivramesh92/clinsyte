const SurveyResultsDashBoard = (props) => {

  var { questions, token, getQuestionStats, patients } = props;

  var getTitleForCollapse = (description, serial) => {
    return (
      <div>
        <div className = 'vertically-top font-bold'>
          { serial }.&nbsp;&nbsp;
        </div>
        <div className = 'vertically-top'>
          { capitalize(description) }
        </div>
      </div>
    );
  }

  var renderDashBoardItem = (question, index) => {
    return (
      <CollapsingPanel key = { question.id }
        title = { getTitleForCollapse(question.description, index + 1) }
          expand = { true }>
        <SurveyDashBoardItem question = { question }
          token = { token }
          getQuestionStats = { getQuestionStats }
          patients = { patients }
        />
      </CollapsingPanel>
    );
  }

  return (
    <div>
     { renderItems(questions, renderDashBoardItem) }
    </div>
  )
}

SurveyResultsDashBoard.propTypes = {
  questions: PropTypes.array.isRequired,
  token: PropTypes.object.isRequired,
  getQuestionStats: PropTypes.func.isRequired,
  patients: PropTypes.array.isRequired
}
