/*
time related utiliy methods
 */
const getHoursIn12HourMode = (seconds) => {
  return getHours(seconds, '12');
}

const getHours = (seconds, mode = '24') => {
  var hourNumber = seconds/60/60;
  var min = Math.trunc((hourNumber - Math.floor(hourNumber)) * 60);
  if ( mode === '24' ){
    return padIfOneDigit(Math.floor(hourNumber)) + ':' + padIfOneDigit(min);
  }
  else{
    var hr = Math.trunc(hourNumber) % 12;
    return  ( hr ? padIfOneDigit(hr) : 12 ) + ':' + padIfOneDigit(min) + ' ' + (seconds > 43199 ? 'PM' : 'AM')
  }
}

const getCalendarRanges = () => {
  return [{
    start: moment().startOf('Day'),
    end: moment().add(30, 'd')
  }];
}

const getSlotsInSlotTiming = (start, end, day, range = [], message = SLOT_TIME_MESSAGE) => {
  var slots = _.range( start, end, SLOT_TIME );
  return _.map(slots, function(s){
    return {
      title: message,
      start: getHours(s),
      end: getHours(s + SLOT_TIME),
      dow: [ getDayNumber(day) ],
      message: 'Click to create appointment request',
      ranges: getCalendarRanges().concat(range)
    }
  });
}

const getUnavailableSlotInSlotTiming = (start, end, date, message = SLOT_BUSY_MESSAGE) => {
  var slots = _.range( start, end, SLOT_TIME );
  return _.map(slots, function(s){
    return {
      title: message,
      start: date + 'T' + getHours(s),
      end: date + 'T' + getHours(s + SLOT_TIME),
      message: 'Physician not available',
      ranges: getCalendarRanges(),
      className: 'busy-slot'
    }
  });
}

const getBusySlotForCalendar = (start, end, date, message = SLOT_BUSY_MESSAGE) => {
  return {
    title: message,
    start: date + 'T' + getHours(start),
    end: date + 'T' + getHours(end),
    message: 'This slot is already reserved',
    ranges: getCalendarRanges(),
    className: 'busy-slot'
  }
}

const getTimeInUTC = (date) => {
  return new Date(Date.UTC(date.getFullYear(),
    date.getMonth(),
    date.getDate(),
    date.getHours(),
    date.getMinutes())
  );
}

const getSecondsForTime = (hour = 0, minutes = 0, seconds = 0) => {
  return (hour * 3600 + minutes * 60 + seconds);
}

/*
date related utilities
 */
var monthNames = ["January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"];

const getFullMonthNameDateFullYear = (date) => {
  return monthNames[date.getMonth()] + ' ' + date.getDate() + ', ' + date.getFullYear();
}

/**
 * function to calculate from given date
 * @date {date}
 */
const getAge = (date) => {
  return moment().diff(Number(date), 'years') + 'yrs';
}

/*
days of the week related utilities
 */
days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];

const sortByDays = (collection) => {
  return _.sortBy(collection, item => {
    return _.indexOf(days, item.day);
  })
}

const getDayNumber = (day) => {
  return _.indexOf(days, day);
}
