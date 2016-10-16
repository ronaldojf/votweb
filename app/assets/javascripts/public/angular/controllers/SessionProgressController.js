angular
  .module('votweb.controllers')
  .controller('SessionProgressController', ['$scope', '$interval', '$cable', 'PlenarySession', function($scope, $interval, $cable, PlenarySession) {

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
      if ($scope.votesChannel) { $scope.votesChannel.unsubscribe(); }
    };

    $scope.findCouncillor = function(councillorId) {
      var result;

      for (var i = 0; i < $scope.currentSession.members.length; i++) {
        if ($scope.currentSession.members[i].councillor.id === councillorId) {
          result = $scope.currentSession.members[i].councillor;
          break;
        }
      }

      return result;
    };

    var getPlenarySession = function(plenarySessionId) {
      PlenarySession.details(plenarySessionId)
      .success(function(data) {
        if ($scope.currentSession.id === data.id) {
          $scope.currentSession = data;

          setQueuesChannel($scope.currentSession);
          setPollsChannel($scope.currentSession);
          setVotesChannel($scope.currentSession);

          checkCountdowns($scope.currentSession);
        }
      })
      .error(function(errors) {
        console.log(errors);
      });
    };

    var setPollsChannel = function(plenarySession) {
      $scope.pollsChannel = $scope.cable.subscribe({
        channel: 'PollsChannel',
        room: plenarySession.id
      }, function(data) {
        collectionRefresh(plenarySession.polls, data, {
          callback: function(poll) {
            setCountdown(poll);
          }
        });
      });
    };

    var setVotesChannel = function(plenarySession) {
      $scope.votesChannel = $scope.cable.subscribe({
        channel: 'VotesChannel',
        room: plenarySession.id
      }, function(data) {
        var poll = findPoll(data.poll_id);
        poll.votes = poll.votes || [];

        collectionRefresh(poll.votes, data);
      });
    };

    var setQueuesChannel = function(plenarySession) {
      $scope.queuesChannel = $scope.cable.subscribe({
        channel: 'CouncillorsQueuesChannel',
        room: plenarySession.id
      }, function(data) {
        collectionRefresh(plenarySession.queues, data, {
          callback: function(queue) {
            setCountdown(queue);
          }
        });
      });
    };

    var findPoll = function(pollId) {
      var result;

      for (var i = 0; i < $scope.currentSession.polls.length; i++) {
        if ($scope.currentSession.polls[i].id === pollId) {
          result = $scope.currentSession.polls[i];
          break;
        }
      };

      return result;
    };

    var setCountdown = function(object) {
      clearCountdown(object);

      if (object.countdown > 0) {
        var end = moment().add(object.countdown, 'seconds');
        object.countdownPromise = $interval(function() {
          // +1 para corrigir tempo de criação do registro e entrega do mesmo por websocket
          object.countdown = end.unix() - moment().unix() + 1;

          if (object.countdown <= 0) {
            clearCountdown(object);
          }
        }, 500);
      }
    };

    var collectionRefresh = function(collection, object, options) {
      options = options || {};
      var index = collection.map(function(currentObject) { return currentObject.id; }).indexOf(object.id);

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
    };

    var checkCountdowns = function(plenarySession) {
      for (var i = 0; i < plenarySession.polls.length; i++) {
        setCountdown(plenarySession.polls[i], true);
      };

      for (var i = 0; i < plenarySession.queues.length; i++) {
        setCountdown(plenarySession.queues[i]);
      };
    };

    var tickingClockPromise = $interval(function() {
      $scope.tickingClockDateTime = new Date();
    }, 1000);
  }]);
