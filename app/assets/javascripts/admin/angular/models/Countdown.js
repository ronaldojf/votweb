angular
  .module('votweb.models')
  .service('Countdown', ['$http', '$window', function($http, $window) {
    this.create = function(params) {
      return $http.post($window.localizedPath('admin_countdowns'), (params || {}));
    };

    this.stop = function(countdown) {
      return $http.patch($window.localizedPath('stop_admin_countdown', countdown.id));
    };
  }]);
