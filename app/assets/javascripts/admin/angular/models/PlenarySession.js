angular
  .module('votweb.models')
  .service('PlenarySession', ['$http', '$window', function($http, $window) {
    this.details = function(plenarySessionID) {
      return $http.get($window.localizedPath('admin_plenary_session', plenarySessionID));
    };
  }]);
