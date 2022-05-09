const PhysicianCareteamsView = (props) => {

  var renderAddMember = () => {
    return (
      <div className = 'row'>
        <div className = 'col-sm-8 col-sm-offset-2'>
          <AddMember user = { props.user }
            authToken = { props.token }
            onSearch = { props.onSearch }
            addMember = { props.onAddCareteam }
            searchableUsers = { ['Patient'] }
            disableRoleOptions = { true }
            defaultRole = 'Patient'
            actionName = 'Join Care team'
          />
        </div>
      </div>
    );
  }

  return (
    <div>
      { isPhysician(props.user) ? renderAddMember() : '' }
      <CareteamList pendingInvitationsCount = { props.pendingInvitationsCount }
        token = { props.token }
        onCareteamRemove = { props.onCareteamRemove }
        careteams = { props.careteams }
        requests = { props.requests }
      />
    </div>
  );
}
