angular.module('customerportal').controller('DashboardOverviewController', function ($rootScope, $location, $scope, CallService, ExportService, ChartService) {

    $scope.typeMap = { "attacksMonitored": "count", "attacksBlocked": "count" };
    $scope.filterTime = TimeFilter;
    $scope.threatLevels = ThreatLevels;
    $scope.legendMap = LegendMap;
    $scope.reportType = ReportType;
    
    $scope.init = function () {        
        ChartService.displayLimit = 5;
        ChartService.legendEnabled = false;
        
        $scope.cardData = null;
        $scope.cardDetailedData = {};
        $scope.detailedTitle = "";
        $scope.getCardData();
        $scope.export = ExportService;
        $scope.selectedFilterTime = { "label": "7 Days", "value": 168 };
        $rootScope.getDomainList($scope.preparePanels);
    };

    $scope.preparePanels = function () {
        $scope.panels = [];
        $scope.callCount = $rootScope.domainList.length;
        
        _.each($rootScope.domainList, function (domain) {
            var panel = {};
            panel.parentId = domain.name;
            panel.isLoading = true;
            panel.chartType = "DONUT";
            panel.level = domain.level;

            $scope.panels.push(panel);
        });

        $scope.startGetChartData();
    };

    // Get card views data
    // Only the count-threat map
    $scope.getCardData = function () {
        CallService.get("/api/dashboard/overview/summary", {}, function (err, data) {
            if (err) {
                // Handler error
            } else {
                $scope.cardData = data.result;
                overviewSticky();
                setTimeout(function() {
                        cardViewCounter();
                    }, 500);   
                }
        });
    };

    // Get detailed card view data
    // Only the domain-count map
    $scope.getDetailedData = function (parentItem, subItem, title) {
        $scope.detailedTitle = title;
        $scope.cardDetailedData.data = [];

        CallService.get("/api/dashboard/" + parentItem + "/" + subItem, {}, function (err, data) {
            if (err) {
                // Handler error
            } else {
                $scope.cardDetailedData.data = data.result;
                $scope.cardDetailedData.type = $scope.typeMap.hasOwnProperty(subItem) ? $scope.typeMap[subItem] : "bool";
            }
        });
    };

    $scope.exportPage = function () {
        $scope.export.reportName('Dashboard Overview');
        $scope.export.partnerName('cWatch Customer Portal');
        $scope.export.reportType($scope.reportType.dashboardOverview);        
        $scope.export.reportData({ domains: $rootScope.domainList, cardData: $scope.cardData, panels: $scope.panels});
        $scope.export.selectedFilterTime($scope.selectedFilterTime.value);
        $scope.export.exportPage();
    };

    $scope.getChartDataCallback = function () {
        $scope.callCount--;
        if ($scope.callCount <= 0) {
            $scope.callCount = 0;
            console.log("Ready to launch");
            window.status = "ready";
        } else {
            window.status = "loading";
        }
    };
    
    $scope.getChartData = function(panel) {
        ChartService.getData("/api/dashboard/overview/chartdata", {domain:panel.parentId}, panel, $scope.selectedFilterTime.value, null, $scope.getChartDataCallback);
    };

    // Start get chart data
    $scope.startGetChartData = function () {
        $scope.panels.forEach(function (panel) {
            $scope.getChartData(panel);
        }, this);
        /*        
        for(var i = 0; i < $scope.panels.length; i++) {
            (function (panel) {
                $scope.getChartData(panel);
            })($scope.panels[i]);    
        }//*/
    };
});