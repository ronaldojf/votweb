angular
  .module('votweb.models')
  .service('SessionItem', ['$http', '$window', function($http, $window) {
    this.update = function(id, params) {
      return $http.patch($window.localizedPath('admin_session_item', id), {session_item: (params || {})});
    };
  }]);
