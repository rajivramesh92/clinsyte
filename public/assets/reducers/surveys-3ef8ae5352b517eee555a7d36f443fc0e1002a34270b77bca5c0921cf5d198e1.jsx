const initialState = {};

const onSetSurveys = (state, action) => {
  return [...action.data]
}

const onUpdateSurveys = (state, action) => {
  return sortSurveys(_.reject(state, { id: action.data.id }).concat(action.data));
}

const onStartResponse = (requests, action) => {
  var id = action.data.requestId;
  var started_at = action.data.startedAt;
  var state = 'started';
  return sortSurveys(_.reject(requests, { id }).concat(Object.assign({},_.findWhere(requests, { id }), { started_at, state })));
}

const onAddSurvey = (surveys, action) => {
  return surveys.concat(action.data);
}

const onAppendSurveys = (surveys, action) => {
  return sortSurveys([...surveys].concat(action.data));
}

const onRemoveTPDSurveys = (requests, action) => {
  return _.reject([...requests], req => req.survey.treatment_plan_dependent);
}

const sortSurveys = (surveys) => {
  return _.sortBy(surveys, 'id').reverse();
}

const surveys = createReducer(initialState, {
  [SET_SURVEYS]: onSetSurveys,
  [UPDATE_SURVEYS]: onUpdateSurveys,
  [START_RESPONSE]: onStartResponse,
  [ADD_SURVEY]: onAddSurvey,
  [APPEND_SURVEYS]: onAppendSurveys,
  [REMOVE_TPD_SURVEYS]: onRemoveTPDSurveys
});
