angular
  .module('votweb.controllers')
  .controller('PartiesController', ['$scope', '$window', 'NgTableService', function($scope, $window, NgTableService) {
    $scope.NgTableService = NgTableService;

    $scope.init = function(config) {
      $scope.filters  = config.filter;
      $scope.tableParams = $scope.NgTableService.init({
        page: config.page,
        count: config.count,
        sorting: config.sorting,
        filter: $scope.filters,
        url: $window.localizedPath('admin_parties')
      });
    };
  }]);
