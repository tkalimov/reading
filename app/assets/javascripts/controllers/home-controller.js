AlphaApi.controller('HomeCtrl', function($scope, $http, $rootScope, $location, StatsSummary) {
  console.log('HomeCtrl');
  var data = StatsSummary.get({}, 
    function() {
      $scope.articles = data.articles;
      $scope.videos = data.videos;
      debugger
      console.log('success');
      $scope.articleChartConfig = {
          options: {
              chart: {
                  type: 'column'
              },
              legend: {
                   enabled: false
              },
          },
          series: [
          {name: 'Words Read', data: $scope.articles.data}],
          title: {
              text: "See how much reading you've done!"
          },
          xAxis: {
                categories: $scope.articles.labels
            },
          yAxis: {
            title: {text: "Words read"}
          },
          credits: {
              enabled: false
          },
          loading: false
      }

      $scope.videoChartConfig = {
          options: {
              chart: {
                  type: 'column'
              },
              legend: {
                   enabled: false
              },
          },
          series: [
          {name: 'Words Read', data: $scope.articles.data}],
          title: {
              text: "See how much reading you've done!"
          },
          xAxis: {
                categories: $scope.articles.labels
            },
          yAxis: {
            title: {text: "Words read"}
          },
          credits: {
              enabled: false
          },
          loading: false
      }
    },
    function() {
      console.log('error');
    }
  ); // Calls: GET /api/v1/pocket/pocket_list/
  



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
