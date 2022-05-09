const PreLoader = ({ visible }) => (
  <div className = { visible ? 'spinner': 'hidden' }>
    <div className = 'main-bouncer'></div>
    <div className = 'sub-bouncer'></div>
  </div>
)

PreLoader.propTypes = {
  visible: PropTypes.bool.isRequired
}
