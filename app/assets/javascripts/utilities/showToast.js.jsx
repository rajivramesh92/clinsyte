//function to display toast to show messages regarding the status of a process
const TOAST_TIMEOUT = 3500;
const notificationElement = $('#alert-notification');

const showToast = (messages, type, timeout=TOAST_TIMEOUT) => {
  var id = 'toast-' + Date.now();
  var messageString = '';

  if(messages instanceof Array){
    messages.forEach(message => {
      messageString += ('<li>' + message + '</li>');
    })
  }
  else{
    messageString = messages;
  }

  hideToast(0);
  var close = '<i class="jp-close-btn icofont icofont-close"></i>';
  var toast = '<div class = "jp-toast animated fadeInUp toast-' + type + ' " id = "' + id + '" >' + close + messageString + '</div>';

  $('html, body').animate({
    scrollTop: notificationElement.offset()
  });

  notificationElement.html(toast);
  hideToast(timeout);
  return id;
}

const hideToast = (timeout) => {
  $(".jp-close-btn").click(function() {
    $('.jp-toast').stop(true,true).remove();
  });
  clearTimeout(window.toastID);
  window.toastID = setTimeout(() => {
    $('.jp-toast').addClass('fadeOutDown').slideUp(800);
  }, ( timeout || TOAST_TIMEOUT ));
}

const showMessage = (location) => {
  function decode(input){
    return decodeURIComponent(input.replace(/\+/g, " "));
  }

  function getQueries() {
    var url = window.location.search.split('?')[1];
    if(url){
      return url.split("&").map(function(query){
        params = query.split('=')
        return [ decode(params[0]), decode(params[1]) ];
      });
    }
  }

  try{
    var queries = getQueries();
    var possibleAlerts = [ 'notice', 'error' ]
    if( queries && queries.length && (possibleAlerts.indexOf(queries[0][0]) != -1) ){
      showToast(queries[0][1], (queries[0][0] == 'notice' ? 'success' : 'error'));
    }
  }
  catch(e){ console.log('Unable to show message:' + e.message); }
}
