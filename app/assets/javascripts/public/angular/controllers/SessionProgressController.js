angular
  .module('votweb.controllers')
  .controller('SessionProgressController', ['$scope', '$interval', '$cable', '$timeout', '$filter', 'PlenarySession',
      function($scope, $interval, $cable, $timeout, $filter, PlenarySession) {

    $scope.cable = $cable();
    $scope.windowHeight = window.outerHeight;
    $scope.currentPoll = {};
    $scope.currentQueue = {};
    $scope.voteTypes = {approvation: 'SIM', rejection: 'NÃO', abstention: 'ABSTENÇÃO'};
    $scope.voteClasses = {approvation: 'text-navy', rejection: 'text-danger', abstention: 'text-muted'};

    var inactivityCountdownPromise;
    var calculatePieChartHeight = function() { return window.top.outerHeight * .30; };
    angular.element(window).on('resize', function() { $scope.pieChartHeight = calculatePieChartHeight(); });

    $scope.pieChart = c3.generate({
      bindto: '#pie',
      size: {
        height: calculatePieChartHeight()
      },
      data: {
        type: 'pie',
        columns: [
          [$scope.voteTypes.approvation, 0],
          [$scope.voteTypes.rejection, 0],
          [$scope.voteTypes.abstention, 0]
        ],
        colors: {
          'SIM': '#1ab394',
          'NÃO': '#ed5565',
          'ABSTENÇÃO': '#c2c2c2'
        }
      }
    });

    $scope.$watch('pieChartHeight', function(newHeight) {
      if (!$scope.isApplyingNewHeight) {
        $scope.isApplyingNewHeight = true;

        $timeout(function() {
          $scope.pieChart.resize({height: $scope.pieChartHeight});
          $scope.isApplyingNewHeight = false;
        }, 1000);
      }
    });

    $scope.$watchCollection('currentPoll.votes', function(newVotes, oldVotes) {
      if ((newVotes || []).length !== (oldVotes || []).length) {
        $scope.currentPoll.approvationCount = $filter('filter')(newVotes, {kind: 'approvation'}).length;
        $scope.currentPoll.rejectionCount = $filter('filter')(newVotes, {kind: 'rejection'}).length;
        $scope.currentPoll.abstentionCount = $filter('filter')(newVotes, {kind: 'abstention'}).length;

        $scope.pieChart.load({
          columns: [
            [$scope.voteTypes.approvation, $scope.currentPoll.approvationCount],
            [$scope.voteTypes.rejection, $scope.currentPoll.rejectionCount],
            [$scope.voteTypes.abstention, $scope.currentPoll.abstentionCount]
          ]
        });
      }
    });

    $scope.$watchCollection('currentSession.members', function(newMembers, oldMembers) {
      if ((newMembers || []).length !== (oldMembers || []).length) {
        $scope.currentSession.splittedMembers = $filter('chunk')(newMembers, 10);
      }
    });

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

    $scope.isToShowCouncillorsList = function() {
      return $scope.currentSession && ($scope.currentEvent === 'queue' || $scope.currentPoll.process === 'named');
    };

    $scope.getCouncillorCurrentVote = function(councillorId) {
      var result;

      for (var i = 0; i < ($scope.currentPoll.votes || []).length; i++) {
        if ($scope.currentPoll.votes[i].councillor_id === councillorId) {
          result = $scope.currentPoll.votes[i];
          break;
        }
      };

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
            setCountdown('poll', poll);
          }
        });
      });
    };

    var setVotesChannel = function(plenarySession) {
      $scope.votesChannel = $scope.cable.subscribe({
        channel: 'VotesChannel',
        room: plenarySession.id
      }, function(data) {
        var poll = getPoll(data.poll_id);
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
            setCountdown('queue', queue);
          }
        });
      });
    };

    var getPoll = function(pollId) {
      var result;

      for (var i = 0; i < $scope.currentSession.polls.length; i++) {
        if ($scope.currentSession.polls[i].id === pollId) {
          result = $scope.currentSession.polls[i];
          break;
        }
      };

      return result;
    };

    var setCountdown = function(type, object) {
      clearCountdown(object);

      if (object.countdown > 0) {
        var end = moment().add(object.countdown, 'seconds');
        inactivityCountdown('off');
        $scope[type === 'poll' ? 'currentPoll' : 'currentQueue'] = object;

        object.countdownPromise = $interval(function() {
          // +1 para corrigir tempo de criação do registro e entrega do mesmo por websocket
          object.countdown = end.unix() - moment().unix() + 1;
          $scope.currentEvent = type;

          if (object.countdown <= 0) {
            clearCountdown(object);
            inactivityCountdown('on');
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
      $scope.currentPoll = {};
      $scope.currentQueue = {};
    };

    var checkCountdowns = function(plenarySession) {
      for (var i = 0; i < plenarySession.polls.length; i++) {
        setCountdown('poll', plenarySession.polls[i], true);
      };

      for (var i = 0; i < plenarySession.queues.length; i++) {
        setCountdown('queue', plenarySession.queues[i]);
      };
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

    var inactivityCountdown = function(turnTo) {
      $timeout.clear(inactivityCountdownPromise);

      if (turnTo === 'on') {
        inactivityCountdownPromise = $timeout(function() {
          delete $scope.currentEvent;
          $scope.currentPoll = {};
          $scope.currentQueue = {};
        }, 5 * 60 * 1000); // 5 minutos
      }
    };
  }]);
