angular.module('customerportal').controller('DashboardAttacksController', function ($rootScope, $location, $scope, CallService, ChartService, ExportService, NgMap) {

    $scope.init = function () {
        ChartService.displayLimit = 5;
        ChartService.legendEnabled = true;

        $scope.reportType = ReportType;
        $scope.filterTime = TimeFilter;
        $scope.mapStyle = MapStyle;
        $scope.clusterStyles = ClusterStyles;
        $scope.nFormatter = NFormatter;
        $scope.export = ExportService;

        $scope.selectedFilterTime = $scope.filterTime[0];
        $scope.timeFilter = $scope.selectedFilterTime.value;
        $scope.timeIndex = 0;

        $scope.resetData();
    };

    $scope.resetData = function () {
        // 1 map, 2 chartData
        $scope.callCount = 3;

        $scope.mapLoading = true;
        $scope.mapData = [];
        $scope.tableData = [];

        if ($rootScope.dashboardMarkerClusterer !== undefined && $rootScope.dashboardMarkerClusterer !== null) {
            $rootScope.dashboardMarkerClusterer.clearMarkers();
            $rootScope.dashboardMarkerClusterer = null;
        }

        $scope.panel = {};
        $scope.monitoredPanel = {};
        $scope.protectedPanel = {};

        $scope.panel.isLoading = true;
        $scope.panel.chartType = "LINE";

        $scope.monitoredPanel.isLoading = true;
        $scope.monitoredPanel.chartType = "LINE";

        $scope.protectedPanel.isLoading = true;
        $scope.protectedPanel.chartType = "LINE";

        $scope.getMapData();
        $scope.getChartData();
    };

    $scope.getMapData = function () {
        var toTime = (new Date()).getTime();
        var fromTime = toTime - ($scope.timeFilter * 1000 * 60 * 60);

        CallService.post("/api/dashboard/attacksummary/map", { fromTime: fromTime, toTime: toTime }, function (err, data) {
            if (err) {
                // Handle error
            } else {
                $scope.mapData = data.result;
                $scope.mapTotalCount = 0;
                $scope.mapData.forEach(function (element) {
                    $scope.mapTotalCount += element.value;
                }, this);

                NgMap.getMap().then(function (map) {
                    var dynMarkers = [];
                    var LatLngList = [];
                    var bounds = new google.maps.LatLngBounds();

                    $scope.mapData.forEach(function (marker) {
                        // Get position of marker
                        var latLng = new google.maps.LatLng(marker.lat, marker.lng);

                        // Create info window
                        var infowindow = new google.maps.InfoWindow({
                            content: '<table class="infowindow-table"><tr><th>Country</th><td>' + marker.country + '</td></tr><tr><th>IP</th><td>' + marker.src_ip + '</td></tr><tr><th>Value</th><td>' + marker.value + '</td></tr>                                                                </table>'
                        });

                        // var iconValue = Math.floor(Math.floor((Math.floor((marker.value / $scope.mapTotalCount) * 20) + 1) * 10) / 5) + 1;

                        var mapMarker = new MarkerWithLabel({
                            map: map,
                            icon: '/assets/images/map/m3.png',
                            position: latLng,
                            labelContent: $scope.nFormatter(marker.value),
                            labelContentOrg: marker.value,
                            labelClass: "customMarker",
                            labelInBackground: false
                        });

                        // Set marker click listener to open info window
                        mapMarker.addListener('click', function () {
                            infowindow.open(map, mapMarker);
                        });

                        dynMarkers.push(mapMarker);
                        LatLngList.push(new google.maps.LatLng(marker.lat, marker.lng));
                    }, this);


                    console.log('Dashboard Attacks Total marker added, length: ' + dynMarkers.length);

                    var mcOptions = {
                        gridSize: 100,
                        maxZoom: 5,
                        minimumClusterSize: 1,
                        styles: $scope.clusterStyles,
                        calculator: function (markers) {
                            var count = 0;
                            var formatCount;

                            for (var i = 0; i < markers.length; i++) {
                                count += markers[i].labelContentOrg;
                                formatCount = $scope.nFormatter(count);
                            }
                            var threshold = (Math.floor((count / $scope.mapTotalCount) * 20) + 1);
                            // Custom style can be returned here
                            return {
                                text: formatCount,
                                index: threshold > 1 ? 5 : Math.floor(Math.floor(threshold * 10) / 5) + 1,
                                enableRetinaIcons: true
                            };
                        }
                    };

                    // Create marker clusterer with markers
                    $rootScope.dashboardMarkerClusterer = new MarkerClusterer(map, dynMarkers, mcOptions);

                    LatLngList.forEach(function (latLng) {
                        bounds.extend(latLng);
                    });

                    map.setCenter(bounds.getCenter());
                    map.fitBounds(bounds);
                });

                $scope.tableData = $scope.mapData.slice(0, 10);
                $scope.mapLoading = false;
            }
            // Call count should be decreased after mapData set.
            $scope.callCount--;
        });
    };

    $scope.getChartData = function () {
        var toTime = (new Date()).getTime();
        var fromTime = toTime - ($scope.timeFilter * 1000 * 60 * 60);

        ChartService.getData("/api/dashboard/attacksummary/monitored", { fromTime: fromTime, toTime: toTime }, $scope.monitoredPanel, $scope.timeFilter, null, function (monitoredPanel) {
            ChartService.getData("/api/dashboard/attacksummary/protected", { fromTime: fromTime, toTime: toTime }, $scope.protectedPanel, $scope.timeFilter, null, function (protectedPanel) {
                if (monitoredPanel.chartData.series[0])
                    monitoredPanel.chartData.series[0].name = "Monitored";

                if (protectedPanel.chartData.series[0]) {
                    protectedPanel.chartData.series[0].name = "Protected";
                    monitoredPanel.chartData.series.push(angular.copy(protectedPanel.chartData.series[0]));
                    $scope.panel = angular.copy(monitoredPanel);
                }

                $scope.callCount -= 2;
            });
        });
    };

    $scope.exportPage = function () {
        $scope.export.reportName('Dashboard Attack Summary');
        $scope.export.partnerName('cWatch Customer Portal');
        $scope.export.reportType($scope.reportType.dashboardAttacks);
        $scope.export.reportData({ chartData: $scope.panel, mapData: $scope.mapData, tableData: $scope.tableData });
        $scope.export.selectedFilterTime($scope.timeFilter);
        $scope.export.exportPage();
    };

    $scope.changeSelectedTimeFilter = function (index, hours) {
        $scope.timeFilter = hours;
        $scope.timeIndex = index;
        $scope.resetData();
    };
});