angular
  .module('votweb.controllers')
  .controller('CouncillorsController', ['$scope', '$interval', '$cable', function($scope, $interval, $cable) {
    $scope.tickingClockDateTime = new Date();
    $scope.cable = $cable();

    $scope.initSessions = function(sessions) {
      $scope.sessions = sessions;

      if ($scope.sessions.length === 1) {
        $scope.setCurrentSession($scope.sessions[0]);
      }
    };

    $scope.setCurrentSession = function(session) {
      $scope.currentSession = session;

      setPollsChannel($scope.currentSession);
      setQueuesChannel($scope.currentSession);
    };

    $scope.resetCurrentSession = function() {
      $scope.currentSession = undefined;

      if ($scope.pollsChannel) { $scope.pollsChannel.unsubscribe(); }
      if ($scope.queuesChannel) { $scope.queuesChannel.unsubscribe(); }
    };

    var setPollsChannel = function(plenarySession) {
      $scope.pollsChannel = $scope.cable.subscribe({
        channel: 'PollsChannel',
        room: plenarySession.id
      }, function(data) {
        //
      });
    };

    var setQueuesChannel = function(plenarySession) {
      $scope.queuesChannel = $scope.cable.subscribe({
        channel: 'CouncillorsQueuesChannel',
        room: plenarySession.id
      }, function(data) {
        //
      });
    };

    var tickingClockPromise = $interval(function() {
      $scope.tickingClockDateTime = new Date();
    }, 1000);
  }]);
