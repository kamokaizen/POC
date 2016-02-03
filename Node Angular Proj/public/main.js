var app = angular.module('birrdy', []);

app.controller('TweetLocationController', function($scope, $http) {

    $scope.getTweets = function() {
        $scope.msg = "";
        $http.get('/coord/' + $scope.location + 'km').
        success(function(data, status, headers, config) {
            $scope.tweets = data;
        }).
        error(function(data, status, headers, config) {
            console.log(status);
            $scope.tweets = [];
        });
    };

    // $scope.loadBirrdies();
});