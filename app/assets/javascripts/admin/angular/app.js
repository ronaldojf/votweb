//= require_self
//= require_tree ./controllers/
//= require_tree ./services/
//= require_tree ./filters/
//= require_tree ./directives/

angular.module('votweb.controllers', []);
angular.module('votweb.services', []);
angular.module('votweb.directives', []);
angular.module('votweb.filters', []);

angular.module('votweb', [
    'ngTable',
    'ng-rails-csrf',
    'localytics.directives',
    'votweb.services',
    'votweb.directives',
    'votweb.filters',
    'votweb.controllers'])

  /* Desabilitar interferência do Angular.JS na navegação, evita problemas com TurboLinks */
 .config( ['$provide', function ($provide) {
    $provide.decorator('$browser', ['$delegate', function ($delegate) {
      $delegate.onUrlChange = function () {};
      $delegate.url = function () { return '' };
      return $delegate;
    }]);
  }]);

$(document).on('ready page:load', function(){
  angular.bootstrap(document.body, ['votweb']);
});