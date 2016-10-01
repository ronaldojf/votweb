//= require_self
//= require_tree ./controllers/
//= require_tree ./services/
//= require_tree ./filters/
//= require_tree ./directives/
//= require_tree ./models/

angular.module('votweb.controllers', []);
angular.module('votweb.services', []);
angular.module('votweb.directives', []);
angular.module('votweb.filters', []);
angular.module('votweb.models', []);

angular.module('votweb', [
    'ngTable',
    'ng-rails-csrf',
    'localytics.directives',
    'daterangepicker',
    'ngCable',
    'votweb.services',
    'votweb.directives',
    'votweb.filters',
    'votweb.models',
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
