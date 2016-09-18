//= require_self
//= require_tree ./controllers/

angular.module('votweb.controllers', []);

angular.module('votweb', [
    'ng-rails-csrf',
    'ngCable',
    'votweb.controllers'
])

  /* Desabilitar interferência do Angular.JS na navegação, evita problemas com TurboLinks */
 .config(['$provide', function($provide) {
    $provide.decorator('$browser', ['$delegate', function($delegate) {
      $delegate.onUrlChange = function() {};
      $delegate.url = function() { return ''; };
      return $delegate;
    }]);
  }]);

$(document).on('turbolinks:load', function() {
  angular.bootstrap(document.body, ['votweb']);
});

$(document).on('turbolinks:before-visit', function() {
  var scope = angular.element(document.body).scope();
  if (scope) {
    scope.$destroy();
  }
});
