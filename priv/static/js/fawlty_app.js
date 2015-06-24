angular.module('FawltyApp', [])
.controller('ItemsCtrl', ['$scope', '$http', function($scope, $http) {
  $scope.list = [1,2,3,4,5];
  $scope.data = null;

  $scope.fetch = function() {
    $scope.code = null;
    $scope.response = null;

    $http({method: 'GET', url: "/api/items"}).
    success(function(data, status) {
      $scope.status = status;
      $scope.data = data;
    })
  };

  $scope.fetch();
}]);
