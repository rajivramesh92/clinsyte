const initialState = {
  medicineAlert: {
    show: false,
    planId: null,
    therapyId: null,
    message: null
  }
}

const onShowMedicineAlert = (state, action) => {
  return {
    ...state,
    medicineAlert: {
      show: true,
      planId: action.planId,
      therapyId: action.therapyId,
      message: action.message
    }
  }
}

const onHideMedicineAlert = (state) => {
  return {
    ...state,
    medicineAlert: {
      show: false,
      planId: null,
      therapyId: null,
      message: null
    }
  }
}

const alerts = createReducer(initialState, {
  [SHOW_MEDICINE_ALERT]: onShowMedicineAlert,
  [HIDE_MEDICINE_ALERT]: onHideMedicineAlert
})
