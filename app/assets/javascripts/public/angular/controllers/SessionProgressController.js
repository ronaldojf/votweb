angular
  .module('votweb.controllers')
  .controller('SessionProgressController', ['$scope', '$interval', '$cable', '$timeout', '$filter', 'PlenarySession',
      function($scope, $interval, $cable, $timeout, $filter, PlenarySession) {

    $scope.cable = $cable();
    $scope.windowHeight = window.outerHeight;
    $scope.currentPoll = {};
    $scope.currentQueue = {};
    $scope.currentCountdownRecord = {};
    $scope.voteTypes = {approvation: 'SIM', rejection: 'NÃO', abstention: 'ABSTENÇÃO'};
    $scope.voteClasses = {approvation: 'text-navy', rejection: 'text-danger', abstention: 'text-muted'};
    $scope.objectsNames = {poll: 'currentPoll', queue: 'currentQueue', countdownRecord: 'currentCountdownRecord'};

    var inactivityCountdownPromise;

    angular.element(window).on('resize', function() { recreatePieChart(); });
    $scope.$watchGroup(['currentSession', 'currentEvent'], function() {
      recreatePieChart();
    });

    $scope.$watchCollection('currentPoll.votes', function(newVotes, oldVotes) {
      if ((newVotes || []).length !== (oldVotes || []).length) {
        $scope.currentPoll.approvationCount = $filter('filter')(newVotes || [], {kind: 'approvation'}).length;
        $scope.currentPoll.rejectionCount = $filter('filter')(newVotes || [], {kind: 'rejection'}).length;
        $scope.currentPoll.abstentionCount = $filter('filter')(newVotes || [], {kind: 'abstention'}).length;

        if ($scope.pieChart) {
          $scope.pieChart.load({
            columns: [
              [$scope.voteTypes.approvation, $scope.currentPoll.approvationCount],
              [$scope.voteTypes.rejection, $scope.currentPoll.rejectionCount],
              [$scope.voteTypes.abstention, $scope.currentPoll.abstentionCount]
            ]
          });

          refreshPieChartColumnsVisibility();
        }
      }
    });

    $scope.$watchCollection('currentSession.members', function(newMembers, oldMembers) {
      if ((newMembers || []).length !== (oldMembers || []).length) {
        $scope.currentSession.splittedMembers = $filter('chunk')(newMembers, 10);
      }
    });

    $scope.$watchCollection('currentQueue.councillors_ids', function(newCouncillorsIds, oldCouncillorsIds) {
      if ($scope.currentQueue && (newCouncillorsIds || []).length !== (oldCouncillorsIds || []).length) {
        var councillors = [];
        angular.forEach(newCouncillorsIds, function(councillorId) {
          for (var i = 0; i < $scope.currentSession.members.length; i++) {
            var councillor = $scope.currentSession.members[i].councillor;

            if (councillorId === councillor.id) {
              councillors.push(councillor);
            }
          }
        });

        $scope.currentQueue.splittedCouncillors = $filter('chunk')(councillors, 10);
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

    $scope.currentObject = function() {
      return $scope[$scope.objectsNames[$scope.currentEvent]];
    };

    var recreatePieChart = function() {
      if (!$scope.isApplyingNewHeight) {
        $scope.isApplyingNewHeight = true;

        $timeout(function() {
          if ($scope.pieChart) { $scope.pieChart.destroy(); }

          $scope.pieChart = c3.generate({
            bindto: '#pie',
            size: {
              height: window.top.outerHeight * .30
            },
            data: {
              type: 'pie',
              columns: [
                [$scope.voteTypes.approvation, ($scope.currentPoll.approvationCount || 0)],
                [$scope.voteTypes.rejection, ($scope.currentPoll.rejectionCount || 0)],
                [$scope.voteTypes.abstention, ($scope.currentPoll.abstentionCount || 0)]
              ],
              colors: {
                'SIM': '#1ab394',
                'NÃO': '#ed5565',
                'ABSTENÇÃO': '#c2c2c2'
              }
            }
          });

          refreshPieChartColumnsVisibility();
          $scope.isApplyingNewHeight = false;
        }, 500);
      }
    };

    var getPlenarySession = function(plenarySessionId) {
      PlenarySession.details(plenarySessionId)
      .success(function(data) {
        if ($scope.currentSession.id === data.id) {
          $scope.currentSession = data;

          setQueuesChannel($scope.currentSession);
          setPollsChannel($scope.currentSession);
          setVotesChannel($scope.currentSession);
          setCountdownRecordChannel($scope.currentSession);

          checkCountdowns($scope.currentSession);
        }

        angular.element('#fullscreen-request').modal();
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

    var setCountdownRecordChannel = function(plenarySession) {
      $scope.pollsChannel = $scope.cable.subscribe({
        channel: 'CountdownsChannel',
        room: plenarySession.id
      }, function(data) {
        collectionRefresh(plenarySession.countdowns, data, {
          callback: function(countdownRecord) {
            setCountdown('countdownRecord', countdownRecord);
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
      if (object.countdown <= 0 && object.countdownPromise) {
        inactivityCountdown('on');
      }

      clearCountdown(object);
      if (object.countdown > 0) {
        var end = moment().add(object.countdown, 'seconds');
        inactivityCountdown('off');
        resetCurrentEvent();
        $scope[$scope.objectsNames[type]] = object;

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
    };

    var checkCountdowns = function(plenarySession) {
      var collectionsByEvent = {
        poll: plenarySession.polls,
        queue: plenarySession.queues,
        countdownRecord: plenarySession.countdowns
      };
      var events = Object.keys(collectionsByEvent);

      for (var i1 = 0; i1 < events.length; i1++) {
        for (var i2 = 0; i2 < collectionsByEvent[events[i1]].length; i2++) {
          setCountdown(events[i1], collectionsByEvent[events[i1]][i2]);
        }
      }
    };

    var inactivityCountdown = function(turnTo) {
      $timeout.cancel(inactivityCountdownPromise);

      if (turnTo === 'on') {
        inactivityCountdownPromise = $timeout(resetCurrentEvent, 5 * 60 * 1000); // 5 minutos
      }
    };

    var resetCurrentEvent = function() {
      delete $scope.currentEvent;
      var events = Object.keys($scope.objectsNames);

      for (var i = 0; i < events.length; i++) {
        $scope[$scope.objectsNames[events[i]]] = {};
      }
    };

    var refreshPieChartColumnsVisibility = function() {
      $scope.pieChart[($scope.currentPoll.approvationCount || 0) > 0 ? 'show' : 'hide']($scope.voteTypes.approvation);
      $scope.pieChart[($scope.currentPoll.rejectionCount || 0) > 0 ? 'show' : 'hide']($scope.voteTypes.rejection);
      $scope.pieChart[($scope.currentPoll.abstentionCount || 0) > 0 ? 'show' : 'hide']($scope.voteTypes.abstention);
    };
  }]);
