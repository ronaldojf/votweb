angular
  .module('votweb.models')
  .service('CouncillorsQueue', ['$http', '$window', function($http, $window) {
    this.participate = function(plenarySessionId, queueId) {
      return $http.patch($window.localizedPath('panel_plenary_session_councillors_queue', plenarySessionId, queueId));
    };
  }]);
