angular
  .module('votweb.controllers')
  .controller('SessionManagementController', ['$scope', '$cable', 'PlenarySession', function($scope, $cable, PlenarySession) {
    $scope.cable = $cable();
    $scope.loading = false;

    $scope.$on('$destroy', function() {
      if ($scope.pollsChannel) { $scope.pollsChannel.unsubscribe(); }
      if ($scopes.queuesChannel) { $scope.queuesChannel.unsubscribe(); }
    });

    var collectionRefresh = function(collection, object) {
      var index = collection.map(function(currentObject) { return currentObject.id; }).indexOf(object.id);

      if (index >= 0) {
        angular.extend(collection[index], object);
      } else {
        collection.unshift(object);
      }
    };

    $scope.init = function(plenarySessionId) {
      $scope.loading = true;

      PlenarySession.details(plenarySessionId)
      .success(function(data) {
        $scope.plenarySession = data;

        $scope.setPollsChannel($scope.plenarySession);
        $scope.setQueuesChannel($scope.plenarySession);
      })
      .error(function(errors) {
        console.log(errors);
      })
      .finally(function() {
        $scope.loading = false;
      });
    };

    $scope.setPollsChannel = function(plenarySession) {
      $scope.pollsChannel = $scope.cable.subscribe({
        channel: 'PollsChannel',
        room: plenarySession.id
      }, function(data) {
        collectionRefresh(plenarySession.polls, data);
      });
    };

    $scope.setQueuesChannel = function(plenarySession) {
      $scope.queuesChannel = $scope.cable.subscribe({
        channel: 'CouncillorsQueuesChannel',
        room: plenarySession.id
      }, function(data) {
        collectionRefresh(plenarySession.queues, data);
      });
    };
  }]);
