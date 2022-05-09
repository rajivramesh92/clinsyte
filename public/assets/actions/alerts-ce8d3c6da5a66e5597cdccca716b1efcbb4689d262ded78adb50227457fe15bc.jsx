const showMedicineAlert = (planId, therapyId, message) => {
  return {
    type: SHOW_MEDICINE_ALERT,
    message,
    planId,
    therapyId
  }
}

const hideMedicineAlert = () => {
  return {
    type: HIDE_MEDICINE_ALERT
  }
}
