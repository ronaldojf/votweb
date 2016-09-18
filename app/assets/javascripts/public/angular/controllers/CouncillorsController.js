angular
  .module('votweb.controllers')
  .controller('CouncillorsController', ['$scope', '$interval', function($scope, $interval) {
    $scope.tickingClockDateTime = new Date();

    var tickingClockPromise = $interval(function() {
      $scope.tickingClockDateTime = new Date();
    }, 1000);
  }]);
