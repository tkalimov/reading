AlphaApi.controller('HomeCtrl', function($scope, $http, $rootScope, $location, StatsSummary) {
  console.log('HomeCtrl');
  $scope.dataSummary = StatsSummary.get(); // Calls: GET /api/v1/pocket/pocket_list/
  debugger
  $scope.updateStats = function() {
    $http.post('/api/v1/stats/update', {}, {headers: {'user-token': window.localStorage.getItem("auth_token")}}).
    success(function(response) {
    	console.log(response);   
    }).
    error(function(response) {
    	console.log('error')
    });
  }
  
})
