AlphaApi.controller('SignUpCtrl', function($scope, $http, $location) {
  console.log('SignUpCtrl');
  $scope.registerUser = function(user) {
    $http.post('http://localhost:3000/api/v1/users.json', {user:user}).
      success(function(response) {
        console.log('login successful');
        window.localStorage.setItem("auth_token", response.auth_token);
        $location.path('/home');
      }).
      error(function(response) {
        console.log('error');
    });
  };
})