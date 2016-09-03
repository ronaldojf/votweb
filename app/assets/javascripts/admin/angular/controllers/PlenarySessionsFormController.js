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

      $scope.plenarySession.members.push({
        reference: Math.random().toString(36).substring(3),
        councillor_id: councillor.id,
        councillor: councillor
      });

      $scope.councillorToAdd = undefined;
    };

    $scope.addItem = function(item) {
      if (!item) { return; }
      $scope.plenarySession.items.push(item);
      $scope.itemToAdd = undefined;
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

    $scope.removeItem = function(item) {
      var exitingItemIndex = $scope.plenarySession.items.findIndex(function(currentItem) {
        return currentItem.id === item.id;
      });

      $scope.plenarySession.items.splice(exitingItemIndex, 1);
    };

    $scope.filterAddedCouncillors = function(councillors) {
      return councillors.filter(function(councillor) {
        var member = $scope.plenarySession.members.find(function(member) {
          return member.councillor_id == councillor.id;
        });

        return !member;
      });
    };

    $scope.filterAddedItems = function(itemsList) {
      return itemsList.filter(function(itemFromList) {
        var item = $scope.plenarySession.items.find(function(item) {
          return item.id == itemFromList.id;
        });

        return !item;
      });
    };
  }]);
