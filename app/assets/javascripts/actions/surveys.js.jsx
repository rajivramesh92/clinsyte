const setSurveys = (surveys) => {
  return {
    type: SET_SURVEYS,
    data: surveys
  }
}

const updateSurveys = (surveys) => {
  return {
    type: UPDATE_SURVEYS,
    data: surveys
  }
}

const startResponse = (requestId, startedAt) => {
  return {
    type: START_RESPONSE,
    data: { requestId, startedAt }
  }
}

const addSurvey = (survey) => {
  return {
    type: ADD_SURVEY,
    data: survey
  }
}

const appendSurveys = (surveys) => {
  return {
    type: APPEND_SURVEYS,
    data: surveys
  }
}

const removeTPDSurveys = () => {
  return {
    type: REMOVE_TPD_SURVEYS
  }
}
