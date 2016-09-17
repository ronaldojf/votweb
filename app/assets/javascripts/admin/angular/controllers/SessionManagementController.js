angular
  .module('votweb.controllers')
  .controller('SessionManagementController', [
      '$scope', '$cable', '$timeout', '$interval', 'PlenarySession', 'Poll', 'CouncillorsQueue',
      function($scope, $cable, $timeout, $interval, PlenarySession, Poll, CouncillorsQueue) {

    $scope.cable = $cable();
    $scope.loading = false;
    $scope.countdownRunning = false;

    $scope.$on('$destroy', function() {
      if ($scope.pollsChannel) { $scope.pollsChannel.unsubscribe(); }
      if ($scope.queuesChannel) { $scope.queuesChannel.unsubscribe(); }
    });

    $scope.init = function(plenarySessionId) {
      $scope.loading = true;

      PlenarySession.details(plenarySessionId)
      .success(function(data) {
        $scope.plenarySession = data;
        checkCountdowns($scope.plenarySession);

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
        collectionRefresh(plenarySession.polls, data, {
          callback: function(poll) {
            $scope.setCountdown(poll);
          }
        });
      });
    };

    $scope.setQueuesChannel = function(plenarySession) {
      $scope.queuesChannel = $scope.cable.subscribe({
        channel: 'CouncillorsQueuesChannel',
        room: plenarySession.id
      }, function(data) {
        collectionRefresh(plenarySession.queues, data, {
          callback: function(queue) {
            $scope.setCountdown(queue);
          }
        });
      });
    };

    $scope.createPoll = function(poll) {
      var params = angular.extend(poll || {}, {plenary_session_id: $scope.plenarySession.id});

      if (!$scope.loading && params.duration > 0) {
        $scope.loading = true;
        Poll.create(params)
        .error(function(errors) {
          console.log(errors);
        })
        .finally(function() {
          $scope.loading = false;
          angular.element('#add-poll').modal('hide');
        });
      }
    };

    $scope.createQueue = function(queue) {
      var params = angular.extend(queue || {}, {plenary_session_id: $scope.plenarySession.id});

      if (!$scope.loading && params.duration > 0) {
        $scope.loading = true;
        CouncillorsQueue.create(params)
        .error(function(errors) {
          console.log(errors);
        })
        .finally(function() {
          $scope.loading = false;
          angular.element('#add-queue').modal('hide');
        });
      }
    };

    $scope.stopPoll = function(poll) {
      stopCountdown(Poll.stop, poll);
    };

    $scope.stopQueue = function(poll) {
      stopCountdown(CouncillorsQueue.stop, poll);
    };

    $scope.openPollModal = function() {
      if (!$scope.countdownRunning) {
        angular.element('#add-poll').modal('show');
        $scope.newPoll = { process: 'symbolic', duration: 20 };
        $timeout(function() {
          angular.element('#poll-description').focus();
        }, 600);
      }
    };

    $scope.openQueueModal = function() {
      if (!$scope.countdownRunning) {
        angular.element('#add-queue').modal('show');
        $scope.newQueue = { duration: 20 };
        $timeout(function() {
          angular.element('#queue-description').focus();
        }, 600);
      }
    };

    $scope.setCountdown = function(object) {
      var pollEnd = moment(object.created_at).add(object.duration, 'seconds');
      clearCountdown(object);

      if (pollEnd.isAfter(moment())) {
        object.countdownPromise = $interval(function() {
          object.countdown = pollEnd.unix() - moment().unix();
          $scope.countdownRunning = true;

          if (object.countdown < 0) {
            clearCountdown(object);
          }
        }, 1000);
      }
    };

    var collectionRefresh = function(collection, object, options) {
      options = options || {};
      var index = collection.map(function(currentObject) { return currentObject.id; }).indexOf(object.id);

      if (options.createOnly && index >= 0) { return; }

      if (index >= 0) {
        if (collection[index].deleted_at) {
          collection.splice(index, 1);
        } else {
          angular.extend(collection[index], object);
          if (options.callback) { options.callback(collection[index]); }
        }
      } else {
        collection.unshift(object);
        if (options.callback) { options.callback(collection[0]); }
      }
    };

    var clearCountdown = function(object) {
      if (object.countdownPromise) {
        $interval.cancel(object.countdownPromise);
      }
      delete object.countdownPromise;
      delete object.countdown;
      $scope.countdownRunning = false;
    };

    var stopCountdown = function(promiseMethod, object) {
      if (!object.stopping) {
        object.stopping = true;

        promiseMethod(object)
        .success(function() {
          object.stopped = true;
        })
        .error(function(errors) {
          console.log(errors);
        })
        .finally(function() {
          delete object.stopping;
        });
      }
    };

    var checkCountdowns = function(plenarySession) {
      for (var i = 0; i < plenarySession.polls.length; i++) {
        $scope.setCountdown(plenarySession.polls[i]);
      };

      for (var i = 0; i < plenarySession.queues.length; i++) {
        $scope.setCountdown(plenarySession.queues[i]);
      };
    };
  }]);
