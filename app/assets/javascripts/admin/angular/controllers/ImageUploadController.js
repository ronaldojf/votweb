angular
  .module('votweb.controllers')
  .controller('ImageUploadController', ['$scope', '$timeout', '$q', 'Cropper', function($scope, $timeout, $q, Cropper) {

    var file, data;

    $scope.cropper = {};
    $scope.cropperProxy = 'cropper.first';
    $scope.cropperOptions = {
      scalable: false,
      autoCrop: true,
      crop: function(newData) {
        data = newData;
      }
    };

    $scope.onFile = function(blob) {
      Cropper.encode((file = blob)).then(function(dataUrl) {
        $scope.originalImageDataUrl = dataUrl;
        $timeout(showCropper);
      });
    };

    $scope.generateImage = function() {
      return $q(function(resolve, reject) {
        if (!file || !data) {
          resolve();
        } else {
          $scope.$applyAsync(function() {
            Cropper.crop(file, data).then(Cropper.encode).then(function(dataUrl) {
              $scope.imageDataUrl = dataUrl;
              resolve();
            });
          });
        }
      });
    };

    $scope.submitForm = function($event) {
      if ($scope.formSubmitted) { return; }
      $event.preventDefault();

      $scope.formSubmitted = true;

      $scope.generateImage().then(function() {
        $timeout(function() {
          angular.element('form:first').submit();
        });
      });
    };

    function showCropper() { $scope.$broadcast('show'); }
    function hideCropper() { $scope.$broadcast('hide'); }
  }]);
