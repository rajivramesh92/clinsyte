var iconSizes = {
  '3Times': '3x',
  '2Times': '2x',
  'large': '1-point-3x',
  'semiLarge': '1-point-2x'
}

const Icon = ({ icon, size }) => (
  <i className = { icon + ' cl-icon-' + iconSizes[size]  }></i>
);

Icon.propTypes = {
  icon: PropTypes.string.isRequired,
  size: PropTypes.string
}
