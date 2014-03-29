var AlphaApi = angular.module('AlphaApi', ['ngResource', 'ui.bootstrap', 'ngRoute',"highcharts-ng"]);

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
    .when('/home', {
      templateUrl: "partials/home.html",
      controller: 'HomeCtrl'
    })
    // if none of the above are matched, go to this one
    .otherwise({
      templateUrl: "partials/home.html",
      controller: 'HomeCtrl'
    })
})



// TEST PHRASING TO CHECK THAT ANGULAR WORKS
// POCKET LIST RESOURCE
// http://www.masnun.com/2013/08/28/rest-access-in-angularjs-using-ngresource.html
AlphaApi.factory("StatsSummary", function($resource) {
  return $resource("/api/v1/stats/summary", {}, {
    get: {
      method: 'GET',
      headers: {
        'user-token': window.localStorage.getItem("auth_token")
      }
    }
  });   
})