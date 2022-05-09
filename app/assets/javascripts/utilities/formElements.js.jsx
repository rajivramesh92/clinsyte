const getPasswordField = (id, ref, label) => {
  return (
    <div className = 'form-group'>
      <label htmlFor = { id }>{ label }</label>
      <input type = 'password'
        className = 'form-control'
        id = { id }
        ref ={ ref }
      />
    </div>
  )
}
