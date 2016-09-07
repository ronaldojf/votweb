angular
  .module('votweb.controllers')
  .controller('SessionManagementController', ['$scope', 'PlenarySession', function($scope, PlenarySession) {
    $scope.loading = false;

    $scope.init = function(plenarySessionId) {
      $scope.loading = true;

      PlenarySession.details(plenarySessionId)
      .success(function(data) {
        $scope.plenarySession = data;
      })
      .error(function(errors) {
        console.log(errors);
      })
      .finally(function() {
        $scope.loading = false;
      });
    };
  }]);
