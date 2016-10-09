angular
  .module('votweb.controllers')
  .controller('SessionManagementController', [
      '$scope', '$cable', '$timeout', '$interval', 'PlenarySession', 'Poll', 'CouncillorsQueue', 'SessionItem',
      function($scope, $cable, $timeout, $interval, PlenarySession, Poll, CouncillorsQueue, SessionItem) {

    $scope.cable = $cable();
    $scope.loading = false;
    $scope.countdownRunning = false;

    $scope.$on('$destroy', function() {
      if ($scope.pollsChannel) { $scope.pollsChannel.unsubscribe(); }
      if ($scope.queuesChannel) { $scope.queuesChannel.unsubscribe(); }
      if ($scope.votesChannel) { $scope.votesChannel.unsubscribe(); }
    });

    $scope.init = function(plenarySessionId) {
      $scope.loading = true;

      PlenarySession.details(plenarySessionId)
      .success(function(data) {
        $scope.plenarySession = data;
        checkCountdowns($scope.plenarySession);

        $scope.setPollsChannel($scope.plenarySession);
        $scope.setQueuesChannel($scope.plenarySession);
        $scope.setVotesChannel($scope.plenarySession);
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
            $scope.setCountdown(poll, true);
          }
        });
      });
    };

    $scope.setVotesChannel = function(plenarySession) {
      $scope.votesChannel = $scope.cable.subscribe({
        channel: 'VotesChannel',
        room: plenarySession.id
      }, function(data) {
        var poll = findPoll(data.poll_id);
        poll.votes = poll.votes || [];

        collectionRefresh(poll.votes, data);
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
        angular.element('.nav-tabs [href="#polls"]').tab('show');

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
      verifyMembersPresence();
    };

    $scope.stopQueue = function(poll) {
      stopCountdown(CouncillorsQueue.stop, poll);
    };

    $scope.openPollModal = function(description) {
      if (!$scope.countdownRunning) {
        angular.element('#add-poll').modal('show');
        $scope.newPoll = { description: description, process: 'symbolic', duration: 20 };
        $timeout(function() {
          angular.element('#poll-description').focus();
        }, 600);
      }
    };

    $scope.openPollDetailsModal = function(poll) {
      angular.element('#poll-details').modal('show');
      $scope.pollDetails = poll;
    };

    $scope.openQueueDetailsModal = function(queue) {
      angular.element('#queue-details').modal('show');
      $scope.queueDetails = queue;
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

    $scope.getCouncillor = function(councillorId) {
      var result;

      for (var i = 0; i < $scope.plenarySession.members.length; i++) {
        if ($scope.plenarySession.members[i].councillor.id === councillorId) {
          result = $scope.plenarySession.members[i].councillor;
          break;
        }
      }

      return result;
    };

    $scope.markSessionItemAs = function(sessionItem, acceptance) {
      if (!$scope.loading && sessionItem.acceptance !== acceptance) {
        $scope.loading = true;

        SessionItem.update(sessionItem.id, {acceptance: acceptance})
        .success(function() {
          sessionItem.acceptance = acceptance;
        })
        .error(function(errors) {
          console.log(errors);
        })
        .finally(function() {
          $scope.loading = false;
        });
      }
    };

    $scope.setCountdown = function(object, verifyPresence) {
      clearCountdown(object);

      if (object.countdown > 0) {
        var end = moment().add(object.countdown, 'seconds');
        object.countdownPromise = $interval(function() {
          // +1 para corrigir tempo de criação do registro e entrega do mesmo por websocket
          object.countdown = end.unix() - moment().unix() + 1;
          $scope.countdownRunning = true;

          if (object.countdown <= 0) {
            clearCountdown(object);
            if (verifyPresence) { verifyMembersPresence(); }
          }
        }, 500);
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
        $scope.setCountdown(plenarySession.polls[i], true);
      };

      for (var i = 0; i < plenarySession.queues.length; i++) {
        $scope.setCountdown(plenarySession.queues[i]);
      };
    };

    var findPoll = function(pollId) {
      var result;

      for (var i = 0; i < $scope.plenarySession.polls.length; i++) {
        if ($scope.plenarySession.polls[i].id === pollId) {
          result = $scope.plenarySession.polls[i];
          break;
        }
      };

      return result;
    };

    var verifyMembersPresence = function() {
      PlenarySession.checkMembersPresence($scope.plenarySession.id)
      .success(function(data) {
        for (var i1 = 0; i1 < $scope.plenarySession.members.length; i1++) {
          var currentSession = $scope.plenarySession.members[i1];

          for (var i2 = 0; i2 < data.length; i2++) {
            if (currentSession.id === data[i2].id) {
              currentSession.is_present = data[i2].is_present;
            }
          }
        }
      })
      .error(function(errors) {
        console.log(errors);
      });
    };
  }]);
