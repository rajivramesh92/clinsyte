class PlainTextResponse extends Component {

  getResponse() {
    return this.refs.response.value.trim();
  }

  render() {
    return (
      <textarea rows = '2'
        className = { 'form-control ' + this.props.className }
        ref = 'response'>
      </textarea>
    )
  }
}

PlainTextResponse.propTypes = {
  className: PropTypes.string
}
