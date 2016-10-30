angular
  .module('votweb.filters')
  .filter('chunk', function() {
    return function(collection, quantity) {
      quantity = quantity || 10;
      return [].concat.apply([], (collection || []).map(function(item, i) { return i%quantity ? [] : [collection.slice(i, i+quantity)] }));
    };
  });
