angular
  .module('votweb.models')
  .service('Poll', ['$http', '$window', function($http, $window) {
    this.vote = function(plenarySessionId, pollId, voteType) {
      return $http.patch($window.localizedPath('panel_plenary_session_poll', plenarySessionId, pollId), {vote_type: voteType});
    };
  }]);
