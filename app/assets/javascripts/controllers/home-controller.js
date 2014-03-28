AlphaApi.controller('HomeCtrl', function($scope, $http, $rootScope, $location, StatsSummary) {
  console.log('HomeCtrl');
  var data = StatsSummary.get({}, 
    function() {
      $scope.articles = data.articles;
      $rootScope.article_chart_data = [$scope.articles.last_week.words_read, $scope.articles.last_month.words_read, $scope.articles.last_year.words_read]
      console.log('success');
      $scope.articleChartConfig = {
          options: {
              chart: {
                  type: 'column'
              },
              legend: {
                   enabled: true
              },
          },
          series: [
          {name: 'Words Read', data: $rootScope.article_chart_data}],
          title: {
              text: 'Article tracker'
          },
          xAxis: {
                categories: ['Last Week', 'Last Month', 'Last Year']
            },
          
          credits: {
              enabled: false
          },
          loading: false
      }
      debugger
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
