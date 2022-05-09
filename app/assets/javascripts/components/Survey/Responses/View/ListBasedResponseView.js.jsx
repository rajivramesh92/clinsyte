const ListBasedResponseView = ({ name, selectedOptions }) => {

  var renderOption = (option, index) => {
    return <li key = { index }>{ option }</li>;
  }

  return (
    <div>
      <label className = 'font-bold'>
        Selected options:
      </label>
      <ul className = 'list-unstyled'>
        { renderItems(selectedOptions, renderOption)}
      </ul>
    </div>
  );
}

ListBasedResponseView.propTypes = {
  name: PropTypes.string.isRequired,
  selectedOptions: PropTypes.array.isRequired
}
