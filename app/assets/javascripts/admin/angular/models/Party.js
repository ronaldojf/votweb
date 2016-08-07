angular
  .module('votweb.models')
  .service('Party', ['$http', '$window', function($http, $window) {
    this.all = function(params) {
      return $http.get($window.localizedPath('admin_parties'), (params || {}));
    };
  }]);
