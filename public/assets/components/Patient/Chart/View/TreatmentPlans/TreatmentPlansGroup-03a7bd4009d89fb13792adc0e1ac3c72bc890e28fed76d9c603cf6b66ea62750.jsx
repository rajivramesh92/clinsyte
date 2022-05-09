const TreatmentPlansGroup = (props) => {

  var { user, patientId, approveOrphanPlan, removeOrphanPlan } = props;

  var getOwner = (creator) => {
    if (creator.id == user.id) {
      return 'Me';
    }
    return creator.name;
  }

  var changeOrphanPlan = (planGroupId, action) => {
    return () => {
      action.call(null, planGroupId);
    }
  }

  var renderPopover = (planGroupId) => {
    return (
      <OrphanPlanPopover onApprove = { changeOrphanPlan(planGroupId, approveOrphanPlan) }
        onRemove = { changeOrphanPlan(planGroupId, removeOrphanPlan) }
      />
    );
  }

  var renderPlansGroups = () => {
    return renderItems(props.planGroups, (planGroup, index) => {
      return (
        <div key = { planGroup.id + 'plangGroup' + index }
        className = 'panel panel-default'>
          <div className = 'panel-heading'>
            <h3 className = 'panel-title'>
              { planGroup.title }
            <span className = { 'pull-right ' + (planGroup.orphaned ? 'text-warning' : 'default-color') }>
              { planGroup.orphaned && !isPatient(user) ? renderPopover(planGroup.id) : <UserIcon user = { planGroup.creator }/> }
            </span>
              <em className = 'font-size-18'>
                <div className = 'default-color small margin-top-7'>Created By: { getOwner(planGroup.creator) }&nbsp;&nbsp;</div>
              </em>
            </h3>
          </div>
          <div className = 'panel-body'>
            <TreatmentPlans plans = { planGroup.therapies }
              planGroupId = { planGroup.id }
              showTakeDosage = { isPatient(user) }
              { ..._.omit(props, 'planGroups') }
            />
          </div>
        </div>
      );
    });
  }

  return (
    <div>
      { renderPlansGroups() }
    </div>
  )
}

TreatmentPlansGroup.propTypes = {
  planGroups: PropTypes.array.isRequired,
  patientId: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.number
  ]).isRequired,
  user: PropTypes.object.isRequired,
  approveOrphanPlan: PropTypes.func.isRequired,
  removeOrphanPlan: PropTypes.func.isRequired
}
