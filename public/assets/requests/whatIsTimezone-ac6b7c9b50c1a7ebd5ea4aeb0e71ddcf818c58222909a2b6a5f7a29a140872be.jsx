const getCurrentTimezone = (callback) => {
  $.ajax({
    url: 'http://ip-api.com/json',
    method: 'GET'
  })
  .done(response => callback(response.timezone))
  .fail()
}
