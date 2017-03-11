angular
  .module('votweb.controllers')
  .controller('SessionManagementController', [
      '$scope', '$cable', '$timeout', '$interval', 'PlenarySession', 'Poll', 'CouncillorsQueue', 'SessionItem', 'Countdown',
      function($scope, $cable, $timeout, $interval, PlenarySession, Poll, CouncillorsQueue, SessionItem, Countdown) {

    $scope.cable = $cable();
    $scope.loading = false;
    $scope.countdownRunning = false;

    $scope.$on('$destroy', function() {
      if ($scope.pollsChannel) { $scope.pollsChannel.unsubscribe(); }
      if ($scope.queuesChannel) { $scope.queuesChannel.unsubscribe(); }
      if ($scope.votesChannel) { $scope.votesChannel.unsubscribe(); }
      if ($scope.countdownsRecordChannel) { $scope.countdownsRecordChannel.unsubscribe(); }
      if ($scope.subscriptionsChannel) { $scope.subscriptionsChannel.unsubscribe(); }
    });

    $scope.init = function(plenarySessionId) {
      $scope.loading = true;

      PlenarySession.details(plenarySessionId)
      .success(function(data) {
        $scope.plenarySession = data;
        setAttributesForSubscriptions($scope.plenarySession);
        checkCountdowns($scope.plenarySession);

        $scope.setPollsChannel($scope.plenarySession);
        $scope.setQueuesChannel($scope.plenarySession);
        $scope.setVotesChannel($scope.plenarySession);
        $scope.setCountdownsRecordChannel($scope.plenarySession);
        $scope.setSubscriptionChannel($scope.plenarySession);
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
            $scope.setCountdown(queue, queue.kind === 'attendance');
          }
        });
      });
    };

    $scope.setCountdownsRecordChannel = function(plenarySession) {
      $scope.countdownsRecordChannel = $scope.cable.subscribe({
        channel: 'CountdownsChannel',
        room: plenarySession.id
      }, function(data) {
        collectionRefresh(plenarySession.countdowns, data, {
          callback: function(countdown) {
            $scope.setCountdown(countdown);
          }
        });
      });
    };

    $scope.setSubscriptionChannel = function(plenarySession) {
      $scope.subscriptionsChannel = $scope.cable.subscribe({
        channel: 'SubscriptionsChannel',
        room: plenarySession.id
      }, function(data) {
        setAttributesForSubscription(data);

        collectionRefresh(plenarySession.subscriptions, data, {
          callback: function(subscription) {
            $scope.setCountdown(subscription);
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

    $scope.createQueue = function(queue, attendanceDescription) {
      var params = angular.extend(queue || {}, {
        plenary_session_id: $scope.plenarySession.id,
        description: (queue.kind === 'attendance' ? attendanceDescription : queue.description)
      });

      if (!$scope.loading && params.duration > 0) {
        $scope.loading = true;
        angular.element('.nav-tabs [href="#queues"]').tab('show');

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

    $scope.createCountdownRecord = function(countdown) {
      var params = angular.extend(countdown || {}, {plenary_session_id: $scope.plenarySession.id});

      if (!$scope.loading && params.duration > 0) {
        $scope.loading = true;
        angular.element('.nav-tabs [href="#countdowns"]').tab('show');

        Countdown.create(params)
        .error(function(errors) {
          console.log(errors);
        })
        .finally(function() {
          $scope.loading = false;
          angular.element('#add-countdown').modal('hide');
        });
      }
    };

    $scope.stopPoll = function(poll) {
      stopCountdown(Poll.stop, poll);
      verifyMembersAttendance();
    };

    $scope.stopQueue = function(queue) {
      stopCountdown(CouncillorsQueue.stop, queue);

      if (queue.kind === 'attendance') {
        verifyMembersAttendance();
      }
    };

    $scope.stopCountdownRecord = function(countdownRecord) {
      stopCountdown(Countdown.stop, countdownRecord);
    };

    $scope.openPollModal = function(description) {
      if (!$scope.countdownRunning) {
        angular.element('#add-poll').modal('show');
        $scope.newPoll = { description: description, process: 'named', duration: 20 };
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

    $scope.openQueueModal = function(kind) {
      if (!$scope.countdownRunning) {
        angular.element('#add-queue').modal('show');
        $scope.newQueue = { duration: 20, kind: (kind || 'normal') };
        $timeout(function() {
          angular.element('#queue-' + (kind === 'attendance' ? 'duration' : 'description')).focus();
        }, 600);
      }
    };

    $scope.openCountdownRecordModal = function(description) {
      if (!$scope.countdownRunning) {
        angular.element('#add-countdown').modal('show');
        $scope.newCountdownRecord = { description: description, duration: 120 };
        $timeout(function() {
          angular.element('#countdown-description').focus();
        }, 600);
      }
    };

    $scope.getCouncillor = function(councillorId) {
      var result;

      for (var i = 0; i < (($scope.plenarySession || {}).members || []).length; i++) {
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
            if (verifyPresence) { verifyMembersAttendance(); }
          }
        }, 500);
      }
    };

    $scope.vote = function(poll, voteType) {
      if ($scope.loading) { return; }

      window.swal({
        title: window.I18n.t('js.messages.titles.sure_president_vote', { vote_type: $scope.voteKinds[voteType] }),
        text: window.I18n.t('js.messages.contents.unable_to_undo'),
        type: 'warning',
        showCancelButton: true,
        customClass: 'data-confirm-swal'
      },
      function(isConfirm){
        if (!isConfirm) { return; }

        $scope.loading = true;
        Poll.voteAsPresident(poll, voteType)
        .success(function() {
          poll.president_voted = true;
        })
        .error(function(errors) {
          console.log(errors);
        })
        .finally(function() {
          $scope.loading = false;
        });
      });
    };

    $scope.print = function(options) {
      var titleSplit = ['VotWEB', $scope.plenarySession.title];
      if (!options) { options = {}; }
      if (options.title) { titleSplit.push(options.title); }

      if (options.scope) {
        var keys = Object.keys(options.scope);
        for (var i = 0; i < keys.length; i++) {
          $scope[keys[i]] = options.scope[keys[i]];
        }
      }

      $timeout(function() {
        angular.element(options.element || 'body').print({title: titleSplit.join(' | ')});
      });
    };

    $scope.absentMembersInPoll = function(poll) {
      var councillorsWhoVoted = [];
      var result = [];

      for (var i = 0; i < (poll.votes || []).length; i++) {
        var id = poll.votes[i].councillor_id;
        if (id) { councillorsWhoVoted.push(id); }
      }

      for (var i = 0; i < (($scope.plenarySession || {}).members || []).length; i++) {
        var member = $scope.plenarySession.members[i];
        if (councillorsWhoVoted.indexOf(member.councillor.id) < 0) { result.push(member); }
      }

      return result;
    };

    var collectionRefresh = function(collection, object, options) {
      options = options || {};
      var index = collection.map(function(currentObject) { return currentObject.id; }).indexOf(object.id);

      if (index >= 0) {
        if (object.deleted_at || object._destroyed) {
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
        $scope.setCountdown(plenarySession.queues[i], plenarySession.queues[i].kind === 'attendance');
      };

      for (var i = 0; i < plenarySession.countdowns.length; i++) {
        $scope.setCountdown(plenarySession.countdowns[i]);
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

    var setAttributesForSubscriptions = function(plenarySession) {
      for (var i = 0; i < plenarySession.subscriptions.length; i++) {
        setAttributesForSubscription(plenarySession.subscriptions[i]);
      }
    };

    var setAttributesForSubscription = function(subscription) {
      subscription.councillor = $scope.getCouncillor(subscription.councillor_id);
      subscription.kind_index = Object.keys($scope.subscriptionKinds).indexOf(subscription.kind);
    };

    var verifyMembersAttendance = function() {
      PlenarySession.checkMembersAttendance($scope.plenarySession.id)
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
