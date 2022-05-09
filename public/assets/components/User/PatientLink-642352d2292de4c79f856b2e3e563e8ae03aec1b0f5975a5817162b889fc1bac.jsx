const PatientLink = ({ user, className }) => (
  <span className = { className }>
    <UserIcon user = { user}/>&nbsp;
    <UserLink user = { user}/>
  </span>
)

PatientLink.propTypes = {
  user: PropTypes.object.isRequired,
  className: PropTypes.string
}
