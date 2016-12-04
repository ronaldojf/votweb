angular
  .module('votweb.models')
  .service('Subscription', ['$http', '$window', function($http, $window) {
    this.create = function(plenarySessionID, kind) {
      return $http.post($window.localizedPath('panel_plenary_session_subscriptions', plenarySessionID), { subscription: {kind: kind} });
    };

    this.destroy = function(plenarySessionID, subscriptionID) {
      return $http.delete($window.localizedPath('panel_plenary_session_subscription', plenarySessionID, subscriptionID));
    };
  }]);
