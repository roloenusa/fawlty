angular.module('FawltyApp', [])
.controller('ItemsCtrl', ['$scope', '$http', function($scope, $http) {

  $scope.fetch = function() {
    $scope.code = null;
    $scope.response = null;

    $http({method: 'GET', url: "/api/items"}).
    success(function(data, status) {
      $scope.status = status;

      $scope.items = data.items;
    })
  };

  $scope.itemDone = function(item) {
    $scope.updateItem(item, function(data) {
      item.done = !item.done;
    });
  }

  $scope.updateItem = function(item, _success) {
    $http({method: 'POST', url: "/api/toggle", data: {id: item.id, done: !item.done}})
    .success(_success)
  }

  $scope.fetch();
}]);
