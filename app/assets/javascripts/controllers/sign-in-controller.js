AlphaApi.controller('SignInCtrl', function($scope, $http, $location) {
  console.log('SignInCtrl');
  $scope.signInUser = function(user) {
    $http.post('http://localhost:3000/api/v1/users/sign_in', {user:user}).
      success(function(response) {
        console.log('login successful');
        window.localStorage.setItem("auth_token", response.auth_token);
        $location.path('/home');
      }).
      error(function(response) {
        $scope.errors = response.message;
        console.log('error');
    });
  };
})