const getFormattedDate = (date) => {
  return date.getDate() + "/" + ( date.getMonth()+1 ) + "/" + date.getFullYear();
}

const checkListInputErrors = (list) => {
  if (_.isEmpty(list.name)) {
    return 'Empty name is not allowed while creating lists';
  }
  else if (_.isEmpty(list.optionsAttributes)) {
    return 'Atleast one option should be provided in the lists';
  }
  else if (!_.isEmpty(_.filter(list.optionsAttributes, { name: '' }))) {
    return 'No option should have an emptry value';
  }
  else {
    return false;
  }
}
