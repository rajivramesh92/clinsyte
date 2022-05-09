const ActivitiesLink = ({ to }) => (
  <Link to = { to }
    title = 'View Activities'>
    <Icon icon = { ACTIVITIES_ICON }/>
  </Link>
);

ActivitiesLink.propTypes = {
  to: PropTypes.string.isRequired
}
