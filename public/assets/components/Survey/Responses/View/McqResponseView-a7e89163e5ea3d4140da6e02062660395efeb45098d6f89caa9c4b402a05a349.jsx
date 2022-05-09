const McqResponseView = ({ response }) => (
  <div className = 'pull-left'>
    <div className = 'radio no-margin'>
      <label>
        <input type = 'radio'
          checked = { true }
          disabled = { true }
        />
        <span>
          { response.option }
        </span>
      </label>
    </div>
  </div>
)

McqResponseView.propTypes = {
  response: PropTypes.object.isRequired
}
