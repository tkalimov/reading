var AlphaApi = angular.module('AlphaApi', ['ngResource', 'ui.bootstrap', 'ngRoute']);

// ROUTES FOR PARTIALS

AlphaApi.config(function($routeProvider) {
$routeProvider
    .when('/sign-in', {
      templateUrl: "partials/sign-in.html",
      controller: 'SignInCtrl'
    })
    .when('/sign-up', {
      templateUrl: "partials/sign-up.html",
      controller: 'SignUpCtrl'
    })
    .when('home', {
      url: "/home",
      templateUrl: "partials/home.html",
      controller: 'HomeCtrl'
    })
    // if none of the above are matched, go to this one
    .otherwise({
      templateUrl: "../partials/sign-in.html",
      controller: 'SignInCtrl'
    })
})

// CONTROLLERS

.controller('SignInCtrl', function($scope, $http, $location) {
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

// OTHER JAVASCRIPT ACTIVITIES

// TEST PHRASING TO CHECK THAT ANGULAR WORKS
function AngularRocksCtrl($scope) {
	$scope.message = "Angular Rocks!"
} 

// POCKET LIST RESOURCE
// http://www.masnun.com/2013/08/28/rest-access-in-angularjs-using-ngresource.html
AlphaApi.factory("PocketList", function ($resource) {
	return $resource("/api/v1/stats/pocket_list");
})

// Get all reading returned by the API - 
function PocketListCtrl($scope, PocketList) {
$scope.pocketlists = PocketList.get(); // Calls: GET /api/v1/pocket/pocket_list/
debugger
}; 

function AlertDemoCtrl($scope) {
  $scope.alerts = [
    { type: 'danger', msg: 'Oh snap! Change a few things up and try submitting again.' },
    { type: 'success', msg: 'Well done! You successfully read this important alert message.' }
  ];

  $scope.addAlert = function() {
    $scope.alerts.push({msg: "Another alert!"});
  };

  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
  };

}