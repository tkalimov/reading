var AlphaApi = angular.module('AlphaApi', ['ngResource']);

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
