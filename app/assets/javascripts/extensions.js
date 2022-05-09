// All the javascript extensions needs to be written here
//
Object.assign = _.extend;

//Math.trunc not available in anrdoid web view
Math.trunc = Math.trunc || function(x) {
  return x < 0 ? Math.ceil(x) : Math.floor(x);
}
