angular
  .module('votweb.controllers')
  .controller('CouncillorsController', [
      '$scope', '$interval', '$cable', 'PlenarySession', 'CouncillorsQueue', 'Poll',
      function($scope, $interval, $cable, PlenarySession, CouncillorsQueue, Poll) {

    $scope.loading = false;
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
      getPlenarySession($scope.currentSession.id);
    };

    $scope.resetCurrentSession = function() {
      $scope.currentSession = undefined;

      if ($scope.pollsChannel) { $scope.pollsChannel.unsubscribe(); }
      if ($scope.queuesChannel) { $scope.queuesChannel.unsubscribe(); }
    };

    $scope.voteFor = function(voteType) {
      if ($scope.loading) { return; }
      $scope.loading = true;
      var poll = getCurrent('poll');

      Poll.vote($scope.currentSession.id, poll.id, voteType)
      .error(function(errors) {
        console.log(errors);
      })
      .finally(function() {
        clearCountdown(poll);
        $scope.loading = false;
      });
    };

    $scope.participateInQueue = function() {
      if ($scope.loading) { return; }
      $scope.loading = true;
      var queue = getCurrent('queue');

      CouncillorsQueue.participate($scope.currentSession.id, queue.id)
      .error(function(errors) {
        console.log(errors);
      })
      .finally(function() {
        clearCountdown(queue);
        $scope.loading = false;
      });
    };

    var setPollsChannel = function(plenarySession) {
      $scope.pollsChannel = $scope.cable.subscribe({
        channel: 'PollsChannel',
        room: plenarySession.id
      }, function(data) {
        collectionRefresh(plenarySession.polls, data, {
          callback: function(poll) {
            setCountdown('poll', poll);
          }
        });
      });
    };

    var setQueuesChannel = function(plenarySession) {
      $scope.queuesChannel = $scope.cable.subscribe({
        channel: 'CouncillorsQueuesChannel',
        room: plenarySession.id
      }, function(data) {
        collectionRefresh(plenarySession.queues, data, {
          callback: function(queue) {
            setCountdown('queue', queue);
          }
        });
      });
    };

    var setCountdown = function(type, object) {
      var end = moment(object.created_at).add(object.duration, 'seconds');
      clearCountdown(object);

      if (end.isAfter(moment())) {
        $scope.currentEvent = type;
        object.countdownPromise = $interval(function() {
          object.countdown = end.unix() - moment().unix();

          if (object.countdown < 0) {
            clearCountdown(object);

            if (type === 'poll') {
              var signoutLink = angular.element('[data-method="delete"]');
              signoutLink.removeAttr('data-confirm');
              signoutLink.trigger('click.rails');
            }
          }
        }, 1000);
      }
    };

    var clearCountdown = function(object) {
      if (object.countdownPromise) {
        $interval.cancel(object.countdownPromise);
      }
      delete object.countdownPromise;
      delete object.countdown;
      delete $scope.currentEvent;
    };

    var collectionRefresh = function(collection, object, options) {
      options = options || {};
      var index = collection.map(function(currentObject) { return currentObject.id; }).indexOf(object.id);

      if (index >= 0) {
        angular.extend(collection[index], object);
        if (options.callback) { options.callback(collection[index]); }
      } else {
        collection.unshift(object);
        if (options.callback) { options.callback(collection[0]); }
      }
    };

    var checkCountdowns = function(plenarySession) {
      var isCountdownRunning = false;

      for (var i = 0; i < plenarySession.polls.length; i++) {
        setCountdown('poll', plenarySession.polls[i]);
        if (plenarySession.polls[i].countdownPromise) {
          isCountdownRunning = true;
          break;
        }
      };

      if (!isCountdownRunning) {
        for (var i = 0; i < plenarySession.queues.length; i++) {
          setCountdown('queue', plenarySession.queues[i]);
          if (plenarySession.queues[i].countdownPromise) { break; }
        };
      }
    };

    var getPlenarySession = function(plenarySessionId) {
      PlenarySession.details(plenarySessionId)
      .success(function(data) {
        if ($scope.currentSession.id === data.id) {
          $scope.currentSession = data;

          setPollsChannel($scope.currentSession);
          setQueuesChannel($scope.currentSession);

          checkCountdowns($scope.currentSession);
        }
      })
      .error(function(errors) {
        console.log(errors);
      });
    };

    var getCurrent = function(type) {
      var result;
      var collection = type === 'poll' ? $scope.currentSession.polls : $scope.currentSession.queues;

      for (var i = 0; i < collection.length; i++) {
        if (collection[i].countdownPromise) {
          result = collection[i];
          break;
        }
      }

      return result;
    };

    var tickingClockPromise = $interval(function() {
      $scope.tickingClockDateTime = new Date();
    }, 1000);
  }]);
