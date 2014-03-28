// AlphaApi.controller('VideoStatsCtrl', function($scope, $rootScope, $http) {
//   console.log('VideoStatsCtrl');
    
//   //Get overall results for the survey 
//   $http.get('http://localhost:3000/api/v1/surveys/results', {headers: {'user-token': window.localStorage.getItem("auth_token")}}).
//     success(function(response) {
//       $scope.individual_results = response.individual_results
//       $scope.vertical_results = response.vertical_results
//       $scope.neighborhood_results = response.neighborhood_results
//       $scope.answer_key = response.answer_key
//       $rootScope.question_key =   response.question_key
//       console.log('results got!');

//   //REARRANGE NEIGHBORHOOD DATA FOR POPULATION OF CHARTS
//       $rootScope.neighborhood_chart_data = {} 
//       for(var question in $scope.neighborhood_results) {
//         $rootScope.neighborhood_chart_data[question] = new Array()
//         for(var date in $scope.neighborhood_results[question]) {
//           tempArray = new Array()
//           tempArray.push(Date.parse(date));
//           for(var option_id in $scope.neighborhood_results[question][date]) {
//             tempArray.push($scope.neighborhood_results[question][date][option_id])
//           }

//           if(typeof tempArray[2] === 'undefined') {
//             numerator = 0
//           }
//           else {
//             numerator = tempArray[2]
//          }
          
//           percentage = numerator/(tempArray[1]+numerator)
//           $rootScope.neighborhood_chart_data[question].push([tempArray[0], percentage])
//         }

//         $rootScope.neighborhood_chart_data[question].sort(function(a,b) {
//           return parseInt(a[0],10) - parseInt(b[0],10);
//         })
//       };
//     }).
//       error(function(response) {
//        debugger
//     });

// })

// AlphaApi.controller('VideoChartCtrl', function($scope, $rootScope) {
// 	console.log('VideoChartCtrl');
	

// })