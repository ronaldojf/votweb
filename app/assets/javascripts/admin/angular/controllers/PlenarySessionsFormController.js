angular
  .module('votweb.controllers')
  .controller('PlenarySessionsFormController', ['$scope', function($scope) {
    $scope.dateRangePickerOptions = window.I18n.t('js.daterangepicker_default_options');

    $scope.init = function(session) {
      $scope.plenarySession = session;
      $scope.plenarySession.members = [];
      $scope.plenarySession.period = { period: { startDate: null, endDate: null } };

      if ($scope.plenarySession.start_at || $scope.plenarySession.end_at) {
        $scope.plenarySession.period.startDate = $scope.plenarySession.start_at || null;
        $scope.plenarySession.period.endDate = $scope.plenarySession.end_at || null;
      }
    };

    $scope.addMember = function(councillor) {
      if (!councillor) { return; }

      var exitingMember = $scope.plenarySession.members.find(function(member) {
        return member.councillor_id == councillor.id;
      });

      if (!exitingMember) {
        $scope.plenarySession.members.push({
          reference: Math.random().toString(36).substring(3),
          councillor_id: councillor.id,
          councillor: councillor
        });
      }

      $scope.councillorToAdd = undefined;
    };

    $scope.removeMember = function(member) {
      var exitingMemberIndex = $scope.plenarySession.members.findIndex(function(currentMember) {
        return (currentMember.reference && currentMember.reference === member.reference) || (currentMember.id && currentMember.id === member.id);
      });

      if ($scope.plenarySession.members[exitingMemberIndex]) {
        $scope.plenarySession.members[exitingMemberIndex]._destroy = '1';
      } else {
        $scope.plenarySession.members.splice(exitingMemberIndex, 1);
      }
    };

    $scope.filterAddedCouncillors = function(councillors) {
      return councillors.filter(function(councillor) {
        var member = $scope.plenarySession.members.find(function(member) {
          return member.councillor_id == councillor.id;
        });

        return !member;
      });
    };
  }]);
