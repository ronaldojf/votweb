angular
  .module('votweb.controllers')
  .controller('PlenarySessionsFormController', ['$scope', function($scope) {
    $scope.dateRangePickerOptions = window.I18n.t('js.daterangepicker_default_options');

    $scope.init = function(session) {
      $scope.plenarySession = session;
      $scope.plenarySession.period = { period: { startDate: null, endDate: null } };

      if ($scope.plenarySession.start_at || $scope.plenarySession.end_at) {
        $scope.plenarySession.period.startDate = $scope.plenarySession.start_at || null;
        $scope.plenarySession.period.endDate = $scope.plenarySession.end_at || null;
      }
    };
  }]);
