var forEach = ( collection, action ) => {
  for( var i = 0 ; i < collection.length ; i ++ ){
    action(collection[i]);
  }
}

var remove = ( collection, action ) => {
  var newCollection = [];

  forEach(collection, (element) => {
    if(!action(element)){
      newCollection.push(element);
    }
  });
  return newCollection;
}

var getPatientChartLink = (patient) => {
  return (
    <Link to = { '/users/' + patient.id + '/chart' }>
      { patient.name }
    </Link>
  );
}

var getToken = () => {
  return JSON.parse(localStorage.getItem('authHeaders'));
}

var isEmpty = (object) => {
  return !(object && (!(object instanceof Array) || Object.keys(object).length));
}

const userContainsRole = (user, role) => {
  if (user && role) {
    if (role.toLowerCase() === 'admin') {
      return user.admin;
    }
    else if (role.toLowerCase() === 'study_admin') {
      return user.study_admin;
    }
    else {
      return (user.role && user.role.toLowerCase() === role);
    }
  }
  return false;
}

const isPatient = (user) => {
  return userContainsRole(user, 'patient');
}

const isPhysician = (user) => {
  return userContainsRole(user, 'physician');
}

const isAdmin = (user) => {
  return userContainsRole(user, 'admin');
}

const isCounselor = (user) => {
  return userContainsRole(user, 'counselor');
}

const isCaregiver = (user) => {
  return userContainsRole(user, 'caregiver');
}

const isSupport = (user) => {
  return userContainsRole(user, 'support');
}

const isStudyAdmin = (user) => {
  return userContainsRole(user, 'study_admin');
}

var getDisplayDate = (number) => {
  var d =  new Date(parseInt(number));
  return getFullMonthNameDateFullYear(d);
}

var capitalize = (string) => {
  return string ? _.first(String(string)).toUpperCase() +  _.rest(String(string)).join('') : string;
}

var changeUnderscoreTo = (separator, string) => {
  var string = string.replace(/_/g, ' ');
  return _.map(string.split(' '), word => {
    return capitalize(word);
  })
  .join(separator);
}

var titleFromSnake = (string) => {
  return changeUnderscoreTo(' ', string);
}

var camelFromSnake = (string) => {
  var firstDashPos = _.indexOf(string.split(''), '_');
  return string.substring(0, firstDashPos).concat(changeUnderscoreTo('', string.substring(firstDashPos + 1)));
}

const createObjects = (val, sample) => {
  if(sample && _.isObject(sample)) {
    return _.map(new Array(val), () => {
      return _.create({}, sample)
    })
  }
  else {
    return _.map(new Array(val), _.create)
  }
}

const filterObject = (object, condition) => {
  var keys = _.keys(object);
  var newObject = {};
  _.each(_.keys(object), key => {
    if (_.isMatch(object[key], condition)) {
      newObject[key] = _.clone(object[key]);
    }
  })
  return newObject;
}

const toggleValue = (array, val) => {
  return _.indexOf(array, val) === 0 ? array[1] : array[0];
}

const uniqObjects = collection => {
  var uniqueObjects = new Array();
  _.each(collection, item => {
    var predicate = obj => {
      return _.isEqual(obj, item);
    }
    if (!_.any(uniqueObjects, predicate)) {
      uniqueObjects.push(item);
    }
  });

  return uniqueObjects;
}

const getNext = (array, currentValue) => {
  var length = array.length;
  var currentValueIndex = _.indexOf(array, currentValue);
  if (currentValueIndex === (length - 1)) {
    return array[0];
  }
  else {
    return array[currentValueIndex + 1];
  }
}

const appendArguments = (args, ...newArgs) => {
  _.each(newArgs, argument => {
    args[args.length] = argument;
  });
  return args;
}

const padLeft = (string, val, length) => {
  return _.map(_.range(length - String(string).length), _ => val).join('').concat(string);
}

const toLowerCase = (str) => {
  return str.toLowerCase();
}
