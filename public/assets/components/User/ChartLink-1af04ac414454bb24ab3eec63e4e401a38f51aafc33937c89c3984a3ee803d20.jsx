const ChartLink = ({ user }) => (
  <span title = 'Patient Chart'>
    <Link to = { '/users/' + user.id + '/chart'}>
      { user.name }
    </Link>
  </span>
)

ChartLink.propTypes = {
  user: PropTypes.object.isRequired
}
