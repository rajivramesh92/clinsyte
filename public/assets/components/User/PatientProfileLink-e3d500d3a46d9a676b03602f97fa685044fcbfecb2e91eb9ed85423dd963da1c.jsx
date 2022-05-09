const PatientProfileLink = ({ user }) => (
  <Link to = { '/users/' + user.id }>
    <UserIcon user = { user}/>
  </Link>
)

PatientProfileLink.propTypes = {
  user: PropTypes.object.isRequired
}
