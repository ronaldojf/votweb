angular
  .module('votweb.models')
  .service('Subscription', ['$http', '$window', function($http, $window) {
    this.markAsDone = function(subscriptionId) {
      return $http.patch($window.localizedPath('admin_subscription', subscriptionId), { subscription: { is_done: true } });
    };

    this.markAsUndone = function(subscriptionId) {
      return $http.patch($window.localizedPath('admin_subscription', subscriptionId), { subscription: { is_done: false } });
    };
  }]);
