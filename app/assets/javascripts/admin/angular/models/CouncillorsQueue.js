angular
  .module('votweb.models')
  .service('CouncillorsQueue', ['$http', '$window', function($http, $window) {
    this.create = function(params) {
      return $http.post($window.localizedPath('admin_councillors_queues'), (params || {}));
    };

    this.stop = function(queue) {
      return $http.patch($window.localizedPath('stop_admin_councillors_queue', queue.id));
    };
  }]);
