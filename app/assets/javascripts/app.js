var AlphaApi = angular.module('AlphaApi', ['ngResource']);

// TEST PHRASING TO CHECK THAT ANGULAR WORKS
function AngularRocksCtrl($scope) {
	$scope.message = "Angular Rocks!"
} 

// POCKET LIST RESOURCE
// http://www.masnun.com/2013/08/28/rest-access-in-angularjs-using-ngresource.html
AlphaApi.factory("PocketList", function ($resource) {
	return $resource(
		"/api/v1/pocket/pocket_list/:Id",
		{Id: "@Id" },
		{ 
			"update": {method: "PUT"}
		}
	)
})

// Get all reading returned by the API - 
function PocketListCtrl($scope, PocketList) {
$scope.pocketlists = PocketList.get(); // Calls: GET /api/v1/pocket/pocket_list/
debugger
}; 

// JMK: Follow-up notation to help with recall: 
//	http://weblogs.asp.net/dwahlin/archive/2013/08/16/using-an-angularjs-factory-to-interact-with-a-restful-service.aspx
// 	https://class.coursera.org/startup-001/lecture/index

// .controller('PocketListCtrl', function($scope, $http, PocketList) {
// 	console.log ('PocketListCtrl');

	// $http.get('http://localhost:3000/api/v1/pocket/pocket_list').
 //    success(function(response) {
 //      console.log(response);
 //      $scope.pocketlists = response
 //      debugger
 //    }).
 //    error(function(response) {
 //      debugger
 //    });	
	
// 	GET CALL FOR POCKET LIST INFORMATION
//	$http.get('http://localhost:3000/api/v1/pocket/pocket_list')
//		success(function(response) {
//			console.log('pocket list got!');
//			$scope.pocketlists = response
//		}).

//		error(function(response) {

///		});




  //$scope.pocketlists = Pocketlist.query()
  

