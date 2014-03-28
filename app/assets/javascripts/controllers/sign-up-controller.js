AlphaApi.controller('SignUpCtrl', function($scope, $http, $location) {
  console.log('SignUpCtrl');
  $scope.registerUser = function(user) {
    $http.post('/api/v1/users.json', {user:user}).
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

// angular.module('radd', ['sessionService','recordService','$strap.directives'])
//   .config(['$httpProvider', function($httpProvider){

//         var interceptor = ['$location', '$rootScope', '$q', function($location, $rootScope, $q) {
//             function success(response) {
//                 return response
//             };

//             function error(response) {
//                 if (response.status == 401) {
//                     $rootScope.$broadcast('event:unauthorized');
//                     $location.path('/users/login');
//                     return response;
//                 };
//                 return $q.reject(response);
//             };

//             return function(promise) {
//                 return promise.then(success, error);
//             };
//         }];
//         $httpProvider.responseInterceptors.push(interceptor);
//   }])