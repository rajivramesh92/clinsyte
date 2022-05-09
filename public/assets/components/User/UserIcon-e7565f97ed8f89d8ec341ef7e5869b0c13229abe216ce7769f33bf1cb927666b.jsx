/**
 * component renders icon correspoing to the user's role
 */
const UserIcon = ({ user, size }) => {
  if(user) {
    var role = user.role || 'others';
    return (
      <Icon size = { size }
        icon = { userIcons[role.toLowerCase()] }
      />
    );
  }
  return <i></i>;
}

UserIcon.propTypes = {
  user: PropTypes.object,
  size: PropTypes.string
}

var userIcons = {
  'patient': PATIENT_ICON,
  'physician': PHYSICIAN_ICON,
  'counselor': COUNSELOR_ICON,
  'caregiver': CAREGIVER_ICON,
  'others': OTHER_USER_ICON
};
