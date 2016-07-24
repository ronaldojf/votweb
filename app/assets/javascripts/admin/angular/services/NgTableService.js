angular
  .module('votweb.services')
  .factory('NgTableService', ['$http', 'NgTableParams', function($http, NgTableParams) {
    var ngTable = undefined;
    var config = {};

    return {
      init: function(options) {
        config = options;
        ngTable = new NgTableParams({
          page: config.page,
          count: config.count,
          sorting: config.sorting,
          filter: $.extend(true, {}, config.filter)
        }, {
          filterDelay: typeof(config.filterDelay) == 'undefined' ? 0 : config.filterDelay,
          total: 0,
          getData: function(params) {
            var request = params.url();
            request.format = 'json';

            ngTable.loadingTable = true;
            return $http.get(config.url, {params: request})
              .success(function(data) {
                params.total(data.total);
                if (config.successCallback) {
                  config.successCallback(data);
                }
              }).error(function() {
                if (config.errorCallback) {
                  config.errorCallback();
                }
              }).finally(function() {
                ngTable.loadingTable = false;
                if (config.finallyCallback) {
                  config.finallyCallback();
                }
              });
          }
        });

        return ngTable;
      },

      clearFilters: function(filter) {
        ngTable.parameters().sorting = config.sorting || {};
        Object.keys(filter || {}).forEach(function(key) {
          filter[key] = undefined;
        });

        this.search({});
        $('#filter').focus();
      },

      search: function(filter) {
        ngTable.filter($.extend(true, {}, filter || {}));
      }
    }
  }]);