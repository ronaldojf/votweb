angular
  .module('votweb.directives')
  .directive('fileread', function() {
    return {
      scope: {
        fileread: '='
      },
      link: function (scope, element) {
        element.bind('change', function (changeEvent) {
          var reader = new FileReader();
          reader.onload = function (loadEvent) {
            scope.$apply(function () {
              scope.fileread = loadEvent.target.result;
            });
          };
          if (typeof(changeEvent.target.files[0]) === 'object') {
            reader.readAsDataURL(changeEvent.target.files[0]);
          }
        });
      }
    };
  });
