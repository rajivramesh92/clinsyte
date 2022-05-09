class CareteamMemberOptions extends Component {

  constructor(props){
    super(props);
    this.renderOptions = this.renderOptions.bind(this);
  }

  renderOptions(){
    var member = this.props.member
    if ( isPhysician(member) && member.careteam_role ){
      return (
        <li>
          <Link to = { '/users/' + this.props.member.id + '/calendar' }>
            Make An Appointment
          </Link>
        </li>
      );
    }
  }

  renderMakePrimary() {
    var member = this.props.member;
    var role = member.careteam_role;
    var onMakePrimaryPhysician = this.props.onMakePrimaryPhysician;
    if (isPhysician(member) && role == 'basic') {
      return (
        <li>
          <a href = '#'
          onClick = { onMakePrimaryPhysician }>
            Make Primary Physician
          </a>
        </li>
      );
    }
  }

  render(){
    return (
      <ul className = 'dropdown-menu'>
        { this.renderMakePrimary() }
        { this.renderOptions() }
        <li>
          <Link to = { '/users/' + this.props.member.id }>
            View Profile
          </Link>
        </li>
        <li>
          <a onClick = { () => this.props.onRemoveMember(this.props.member.id) }>
            Remove From Careteam
          </a>
        </li>
      </ul>
    );
  }
}
