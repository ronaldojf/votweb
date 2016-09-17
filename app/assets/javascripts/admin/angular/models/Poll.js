angular
  .module('votweb.models')
  .service('Poll', ['$http', '$window', function($http, $window) {
    this.create = function(params) {
      return $http.post($window.localizedPath('admin_polls'), (params || {}));
    };

    this.stop = function(poll) {
      return $http.patch($window.localizedPath('stop_admin_poll', poll.id));
    };
  }]);
