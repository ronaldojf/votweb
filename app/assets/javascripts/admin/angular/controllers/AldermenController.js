angular
  .module('votweb.controllers')
  .controller('AldermenController', ['$scope', '$window', 'NgTableService', 'Party', function($scope, $window, NgTableService, Party) {
    $scope.NgTableService = NgTableService;
    $scope.parties = [];

    $scope.init = function(config) {
      $scope.filters  = config.filter;
      $scope.tableParams = $scope.NgTableService.init({
        page: config.page,
        count: config.count,
        sorting: config.sorting,
        filter: $scope.filters,
        url: $window.localizedPath('admin_aldermen')
      });
    };

    $scope.loadAllParties = function(params) {
      var page = (params || {}).page || 1;
      var count = (params || {}).count || 50;

      Party.all()
      .success(function(data) {
        data.results.forEach(function(party) {
          $scope.parties.push({id: party.id, abbreviation: party.abbreviation, name: party.name});
        });

        if (data.results.size === count) {
          page++;
          $scope.loadAllParties({count: count, page: page});
        }
      });
    };

    $scope.loadAllParties();
  }]);
