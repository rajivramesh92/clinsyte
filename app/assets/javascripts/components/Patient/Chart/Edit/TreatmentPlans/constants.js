const CONDITION_ASSOCIATION = 'condition';
const SYMPTOM_ASSOCIATION = 'symptom';

const BLANK_PLAN_THERAPY = {
  strain: { id: null },
  dosage_quantity: 0,
  dosage_unit: _.first(DOSAGE_UNITS),
  frequencies: [],
  removeBtnValue: 'Cancel',
  association_entities: [],
  intake_timing: 'as_required'
}
