(function(){
  var mocking = function () {
  };
  var isFunction = function (obj) {
    return typeof obj === 'function';
  }
  mocking.int = function (min, max) {
    if (max == undefined) {
      max = min;
      min = 0;
    }
    return function () {
      return parseInt(Math.random() * (max - min) + min);
    };
  };
  mocking.inc = function (start, step) {
    start = start || 0;
    step = step || 1;
    return function () {
      return start += isFunction(step) ? step() : step;
    };
  };
  mocking.float = function (min, max, fix) {
    return function () {
      return parseFloat((Math.random() * (max - min) + min).toFixed(fix || 0));
    };
  };
  mocking.boolean = function (probability) {
    return function () {
      return Math.random() < (probability >=0 ? probability :  0.5);
    };
  };
  mocking.string = function (length, chars) {
    var chars = (chars || 'abcdefghigklmnopqrstuvwxyz').split(''),
        radomint = mocking.int(0, chars.length);
    return function () {
      var leg = isFunction(length) ? length() : length,
          arr = new Array(leg);
      while (leg > 0) arr[--leg] = chars[radomint()];
      return arr.join('');
    };
  };
  mocking.object = function (obj) {
    var keys = Object.keys(obj);
    return function () {
      var result = {};
      keys.forEach(function (key) {
        result[key] = isFunction(obj[key]) ? obj[key]() : obj[key];
      });
      return result;
    };
  };
  mocking.array = function(content, length) {
    return function () {
      var leg = isFunction(length) ? length() : length,
          arr = new Array(leg);
      while (leg > 0) arr[--leg] = content();
      return arr;
    };
  };
  mocking.oneof = function(candidates) {
    var randomInt = mocking.int(candidates.length);
    return function () {
      candidates[randomInt()];
    }
  };
  if(typeof define != 'undefined'){
    define(mocking);
  } else if (typeof window != 'undefined') {
    window.mocking;
  } else if (typeof module != 'undefined' && module.exports) {
    module.exports = mocking;
  }
})();