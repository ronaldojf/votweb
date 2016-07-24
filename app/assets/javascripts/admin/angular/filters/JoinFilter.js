angular
  .module('votweb.filters')
  .filter('join', [function () {
    return function (collection, separator) {
      return (collection || []).join(separator || ',');
    };
  }]);