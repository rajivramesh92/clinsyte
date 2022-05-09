const LinkButton = (props) => (
  <Link to = { props.to }
    className = { props.className || 'btn btn-primary btn-block' }>
    { props.val }
  </Link>
);

LinkButton.propTypes = {
  to: PropTypes.string.isRequired,
  val: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.element
    ]),
  className: PropTypes.string
}
