angular
  .module('votweb.filters')
  .filter('t', function() {
    return function(scope, options) {
      options = options || {};
      options.scope = options.scope || [];
      options.scope = Array.isArray(options.scope) ? options.scope : options.scope.split('.');
      options.scope.unshift('js');
      options.scope = options.scope.join('.');

      return window.I18n.t(String(scope), options || {});
    };
  });