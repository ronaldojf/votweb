angular
  .module('votweb.filters')
  .filter('truncate', function() {
    return function(str, length) {
        if (!str || !length || str.length <= length) { return (str || ''); }
        return str.substr(0, length) + (length <= 3 ? '' : '...');
      };
  });
