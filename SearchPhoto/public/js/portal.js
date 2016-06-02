var app = angular.module('customerportal', ['ngRoute', 'ngCookies', 'highcharts-ng', 'inform', 'ngResource', 'emguo.poller', 'ngMap']);

app.config(function ($routeProvider) {
    $routeProvider.when('/dashboard/overview', {
        controller: "DashboardOverviewController",
        templateUrl: '../templates/views/dashboard-overview.html'
    })
    $routeProvider.when('/dashboard/attacks', {
        controller: "DashboardAttacksController",
        templateUrl: '../templates/views/dashboard-attacks.html'
    })
    $routeProvider.when('/domains/attacks/:domainId', {
        controller: "DomainAttacksController",
        templateUrl: '../templates/views/domain-attacks.html'
    })
    .otherwise({redirectTo: '/dashboard/overview'});
});

app.config(function() {
    Highcharts.setOptions({
        global: {
            useUTC: false
        }
    });
});

app.config(function ($locationProvider) {
    $locationProvider.html5Mode({
        enabled: true,
        requireBase: false
    });

    $locationProvider.hashPrefix('!');

});



app.run(function ($rootScope, $location, $http, $cookies, CallService) {  
    
    $rootScope.postLoadingFlag = false;
    $http.defaults.xsrfHeaderName = 'XSRF-TOKEN';
    $http.defaults.xsrfCookieName = 'csrftoken';
    
    $rootScope.domainList = null;
    
    $rootScope.$on('$routeChangeStart', function () {
        var requests = CallService.cancelPromises;
        angular.forEach(requests, function (cancelPromise) {
            cancelPromise.defer.promise.status = 499;
            cancelPromise.defer.resolve();
        });
        CallService.cancelPromises = [];
    });
    
    $rootScope.getDomainList = function(callback) {
        if(!$rootScope.domainList) {
            // Get domain list store in the rootscope
            CallService.get("/api/dashboard/domains", {}, function(err,data) {
                if(err) {
                    // Handle error
                } else {
                    $rootScope.domainList = data.result;  
                    callback();
                } 
            });
        } else {
            callback();
        }
    }
});

Highcharts.theme = {
    colors: ['#E6645C', '#55A9DC', '#886DB3', '#6CC080', '#bfc06c' , '#c0946c', '#478eba', '#6c5591', '#5ba36c']
};

// Apply the theme
Highcharts.setOptions(Highcharts.theme);
