const UserLink = ({ user }) => {
  return (
    <Link to = { '/users/' + user.id }>
      { user.name }
    </Link>
  )
}

UserLink.propTypes = {
  user: PropTypes.object.isRequired
}
