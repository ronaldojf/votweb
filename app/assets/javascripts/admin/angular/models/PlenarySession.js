angular
  .module('votweb.models')
  .service('PlenarySession', ['$http', '$window', 'Poll', function($http, $window, Poll) {
    this.details = function(plenarySessionID) {
      return $http.get($window.localizedPath('admin_plenary_session', plenarySessionID));
    };
  }]);
