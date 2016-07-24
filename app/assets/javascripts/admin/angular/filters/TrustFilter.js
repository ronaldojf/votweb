angular
  .module('votweb.filters')
  .filter('trust', ['$sce', function($sce) {
      return function(text, type) {
        return $sce.trustAs(type || 'html', text || '');
      }
    }
  ]);
