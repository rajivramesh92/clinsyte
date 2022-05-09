class ListNameInput extends Component {

  getName() {
    return this.refs.listName.value;
  }

  render() {
    return (
      <div className = 'form-group'>
        <small className = 'blue'>
          List Name
        </small>
        <input className = 'form-control'
          ref = 'listName'
          defaultValue = { this.props.listName }
        />
      </div>
    );
  }
}

ListNameInput.propTypes = {
  listName: PropTypes.string
}
