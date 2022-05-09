const request = (options) => {
  $('input[type="submit"]').attr('disabled','disabled');
  return new Promise((resolve, reject) => {
    var response = $.ajax({
      url: options.url,
      method: options.method,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        ...options.headersToBeSent
      },
      data: options.data
    });
    response.done(data => {
      if (options.requiredHeaders) {
        var headers = {};
        options.requiredHeaders.forEach(header => {
          headers[header] = response.getResponseHeader(header);
        })

        resolve({
          data,
          headers
        })
      }
      else {
        resolve({ data, headers:undefined })
      }
      $('input[type="submit"]').removeAttr('disabled');
    });

    response.fail(error => {
      reject(error)
      $('input[type="submit"]').removeAttr('disabled');
    });
  })
}
