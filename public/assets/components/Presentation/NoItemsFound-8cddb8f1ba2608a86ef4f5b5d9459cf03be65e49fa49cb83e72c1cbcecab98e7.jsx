const NoItemsFound = ({ message, icon }) => (
  <div className='box disabled-text'>
    <center>
      <Icon icon = { icon }
        size = '3Times'
      />
      <br />
      <h6 className='disabled-text'>
        { message }
      </h6>
    </center>
  </div>
);

NoItemsFound.propTyps = {
  message: PropTypes.string.isRequired,
  icon: PropTypes.string
}
