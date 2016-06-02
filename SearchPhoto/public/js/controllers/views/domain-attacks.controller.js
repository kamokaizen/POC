angular.module('customerportal').controller('DomainAttacksController', function ($rootScope, $location, $scope, $routeParams, CallService, ChartService, ExportService, NgMap) {
    var DomainAttacksMenu = [{ isLoading: true, chartType: "PIECHART", title: "What are the origin of attacker's?", service: "/api/domain/attacks/originAttackers" },
        { isLoading: true, chartType: "AREA", title: "Daily attack trend", service: "/api/domain/attacks/dailyTrend" },
        { isLoading: true, chartType: "TABLE", title: "Repeat Attackers", service: "/api/domain/attacks/repeatAttackers" },
        { isLoading: true, chartType: "PIECHART", title: "Blocked attacks by type", service: "/api/domain/attacks/originAttackers" },
        { isLoading: true, chartType: "PIECHART", title: "Top 10 Targetted URI", service: "/api/domain/attacks/originAttackers" }
    ];


    $scope.init = function () {
        ChartService.displayLimit = 10;
        ChartService.legendEnabled = true;

        $scope.domainId = $routeParams.path ? $routeParams.path : "-1";
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
        // 1 map, 5 chart
        $scope.callCount = 6;

        $scope.mapLoading = true;
        $scope.mapData = [];

        if ($rootScope.domainMarkerClusterer !== undefined && $rootScope.domainMarkerClusterer !== null) {
            $rootScope.domainMarkerClusterer.clearMarkers();
            $rootScope.domainMarkerClusterer = null;
        }

        $scope.tableData = [];
        $scope.panels = angular.copy(DomainAttacksMenu);

        $scope.startGetChartData();
        $scope.getMapData();
    };

    $scope.getMapData = function () {
        var toTime = (new Date()).getTime();
        var fromTime = toTime - ($scope.timeFilter * 1000 * 60 * 60);

        CallService.post("/api/domain/attacks/map", { fromTime: fromTime, toTime: toTime, domain: $scope.domainId }, function (err, data) {
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

                        //var iconValue = Math.floor(Math.floor((Math.floor((marker.value / $scope.mapTotalCount) * 20) + 1) * 10) / 5) + 1;

                        // Create marker
                        var mapMarker = new MarkerWithLabel({
                            map: map,
                            icon: '/assets/images/map/m3.png',
                            position: latLng,
                            labelContent: $scope.nFormatter(marker.value),
                            labelContentDefault: marker.value,
                            labelClass: "customMarker",
                            labelInBackground: false
                        });

                        // Set marker click listener to open info window
                        mapMarker.addListener('click', function () {
                            infowindow.open(map, mapMarker);
                        });

                        dynMarkers.push(mapMarker);
                        LatLngList.push(new google.maps.LatLng(marker.lat, marker.lng));
                    });

                    console.log('Domain Attacks Total marker added, length: ' + dynMarkers.length);

                    var mcOptions = {
                        gridSize: 100,
                        maxZoom: 5,
                        minimumClusterSize: 1,
                        styles: $scope.clusterStyles,
                        calculator: function (markers) {
                            //console.log(markers);
                            var count = 0;
                            var formatCount;

                            for (var i = 0; i < markers.length; i++) {
                                count += markers[i].labelContentDefault;
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
                    $rootScope.domainMarkerClusterer = new MarkerClusterer(map, dynMarkers, mcOptions);

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
    }

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

    $scope.getChartData = function (panel) {
        var toTime = (new Date()).getTime();
        var fromTime = toTime - ($scope.timeFilter * 1000 * 60 * 60);

        ChartService.getData(panel.service, { domain: $scope.domainId, fromTime: fromTime, toTime: toTime }, panel, $scope.timeFilter, null, $scope.getChartDataCallback);
    };

    // Start get chart data
    $scope.startGetChartData = function () {
        $scope.panels.forEach(function (panel) {
            $scope.getChartData(panel);
        }, this);
    };

    $scope.exportPage = function () {
        $scope.export.reportName('Domain Attacks');
        $scope.export.partnerName('cWatch Customer Portal');
        $scope.export.reportType($scope.reportType.domainAttacks);
        $scope.export.reportData({ chartData: $scope.panels, mapData: $scope.mapData });
        $scope.export.selectedFilterTime($scope.timeFilter);
        $scope.export.exportPage();
    };

    $scope.changeSelectedTimeFilter = function (index, hours) {
        $scope.timeFilter = hours;
        $scope.timeIndex = index;
        $scope.resetData();
    };

});