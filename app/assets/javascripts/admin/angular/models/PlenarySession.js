angular
  .module('votweb.models')
  .service('PlenarySession', ['$http', '$window', function($http, $window) {
    this.details = function(plenarySessionID) {
      return $http.get($window.localizedPath('admin_plenary_session', plenarySessionID));
    };

    this.checkMembersPresence = function(plenarySessionID) {
      return $http.post($window.localizedPath('check_members_presence_admin_plenary_session_session_managements', plenarySessionID));
    };
  }]);
