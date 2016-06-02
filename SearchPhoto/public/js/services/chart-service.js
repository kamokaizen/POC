angular.module('customerportal').factory('ChartService', function ($location, CallService) {

    var chartService = {};
    chartService.displayLimit = 5;
    chartService.legendEnabled = false;

    chartService.getTimeInterval = function (time) {
        var toTime = (new Date()).getTime();
        var fromTime = toTime - (time * 1000 * 60 * 60);
        return [fromTime, toTime];
    }

    chartService.fillChartDataSeries = function (chartOpt, aggregations, title, time, fromTime, toTime, pointClickCallback) {
        var dataSerie = [];
        var lineSeries = [];
        var drilldownSeries = [];
        var i = 0;
        if ((chartOpt.options.chart.type === "area" || chartOpt.options.chart.type === "line") && aggregations.aggKeys.length !== 0) {
            dataSerie.push({ name: title, data: [] });
            var hourRange = time;

            for (i = 0; i <= hourRange; i++) {
                lineSeries.push([fromTime + i, 0.0]);
            }

            for (i = 0; i < aggregations.aggKeys.length; i++) {
                var key = aggregations.aggKeys[i];
                lineSeries = lineSeries.map(function (obj) {
                    if (obj[0] === key)
                        obj[1] = aggregations.aggValues[i];
                    return obj;
                });
            }

            var reformattedSeries = lineSeries.map(function (obj) {
                obj[0] *= 3600000;
                return obj;
            });

            dataSerie[0].data = reformattedSeries;
        } else {
            var chartDisplayLimit = chartOpt.options.chart.type === "table" ? aggregations.aggKeys.length : Math.min(aggregations.aggKeys.length, chartService.displayLimit);

            for (i = 0; i < chartDisplayLimit; i++) {
                if (i === 0)
                    dataSerie.push({ name: title, data: [] });

                dataSerie[0].data.push({ name: aggregations.aggKeys[i], y: aggregations.aggValues[i], color: LegendMap[aggregations.aggKeys[i]] });

                if (chartOpt.options.chart.type === "column") {
                    chartOpt.options.xAxis.categories.push(aggregations.aggKeys[i]);
                }
            }

            // Prepare Other
            if (chartDisplayLimit < aggregations.aggValues.length && chartOpt.options.chart.type !== "table") {
                var others = aggregations.aggValues.slice(chartDisplayLimit, aggregations.aggValues.length);
                var sum = _.reduce(others, function (memo, num) { return memo + num; }, 0);

                dataSerie[0].data.push({ name: "Other", y: sum, drilldown: "Other", color: LegendMap["Other"] });

                var drillObject = { name: "Other", id: "Other" };
                var drillData = [];
                for (var j = chartDisplayLimit; j < aggregations.aggKeys.length; j++) {
                    drillData.push({ name: aggregations.aggKeys[j], y: aggregations.aggValues[j], color: LegendMap[aggregations.aggKeys[j]] });
                }
                drillObject.data = drillData;

                drilldownSeries.push(drillObject);
            }
        }


        // Add click callback
        if (pointClickCallback && dataSerie.length !== 0) {
            var events = {};
            events.click = function (event) {
                var clickedChartId = event.currentTarget.parentNode.id;
                clickedChartId = clickedChartId.split("_")[1];

                var pointData = event.point.options;
                pointClickCallback(clickedChartId, pointData);
            };

            dataSerie[0].events = events

            if (drilldownSeries.length !== 0)
                drilldownSeries[0].events = events;
        }

        chartOpt.series = dataSerie;

        if (chartOpt.options.chart.type !== "table")
            chartOpt.options.drilldown.series = drilldownSeries;

        if (dataSerie.length === 0) {
            chartOpt.options.title.text = "No Data Available";

            if (chartOpt.options.chart.type === "column" || chartOpt.options.chart.type === "area") {
                chartOpt.options.xAxis = {};
                chartOpt.options.yAxis = {};
                chartOpt.options.subtitle = {};
            }
        }


    };

    chartService.getData = function (service, sendData, panel, time, pointClickCallback, loadFinishCallback) {
        /*
        var sendData = {};
        var timeInterval = getTimeInterval(time);
        var fromTime = timeInterval[0];
        var toTime = timeInterval[1];
        sendData = {"fromTime" : fromTime, "toTime" : toTime, "chartId" : panel.uid};
        //*/
        var timeInterval = chartService.getTimeInterval(time);
        var fromTime = timeInterval[0];
        var toTime = timeInterval[1];

        CallService.post(service, sendData, function (err, data) {
            var chartOpt;
            if (err) {
                chartOpt = angular.copy(DEFAULT_CHART_OPTIONS);
                chartOpt.options.title.text = "No Data Available";
                chartOpt.options.legend.enabled = chartService.legendEnabled;
                panel.chartData = angular.copy(chartOpt);
                panel.isLoading = false;
            } else {
                chartOpt = angular.copy(DEFAULT_CHART_OPTIONS);

                chartOpt.options.chart.type = GraphTypeMap[panel.chartType];
                chartOpt.options.legend.enabled = chartService.legendEnabled;

                var chartOptionsMap = angular.copy(CHART_OPTIONS_MAP[panel.chartType]);
                chartOpt.options.xAxis = chartOptionsMap["xAxis"] ? chartOptionsMap["xAxis"] : {};
                chartOpt.options.yAxis = chartOptionsMap["yAxis"] ? chartOptionsMap["yAxis"] : {};
                chartOpt.options.subtitle = chartOptionsMap["subtitle"];
                chartOpt.options.title.text = "";
                chartOpt.options.plotOptions = chartOptionsMap["plotOptions"];
                chartOpt.options.tooltip = chartOptionsMap["tooltip"];

                chartService.fillChartDataSeries(chartOpt, data.result.result, panel.title, time, parseInt(fromTime / (60 * 60 * 1000)), parseInt(toTime / (60 * 60 * 1000)), pointClickCallback);

                panel.chartData = angular.copy(chartOpt);
                panel.isLoading = false;
            }

            // return callback
            if (loadFinishCallback)
                loadFinishCallback(panel);
        });
    };

    return chartService;

});

