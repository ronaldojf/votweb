angular
  .module('votweb.directives')
  .directive('ngFocus', ['$timeout', function($timeout) {
    return {
      link: function(scope, element, attrs) {
        scope.$watch(attrs.ngFocus, function(value) {
          if((Array.isArray(value) && value[0] === true) || (value === true)) {
            $timeout(function() {
              element[0].focus();
              scope[attrs.ngFocus] = false;
            }, Array.isArray(value) ? value[1] : 0);
          }
        });
      }
    };
  }]);
