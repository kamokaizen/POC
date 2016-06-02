var DEFAULT_CHART_OPTIONS = {
    options: {
        chart: {
            zoomType: 'x',
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: ''
        },
        credits: {
            enabled: false
        },
        xAxis: {},
        yAxis: {},
        title: {
            text: ''
        },
        subtitle: {},
        tooltip: {},
        plotOptions: {},
        legend: {
            enabled: true,
            itemWidth: 150,
            useHTML: true,
            borderRadius: 0,
            symbolHeight: 12,
            symbolWidth: 12,
            symbolRadius: 6,
            itemMarginTop:3,            
            itemMarginBottom: 3,
            backgroundColor: 'rgba(243, 243, 243, 0)',
            borderWidth: 0,
            itemStyle: { 
                "color": "#333333", 
                "fontSize": "11px", 
                "lineHeight": "12px",
                "fontWeight": "normal" 
            }
        },
        drilldown: {}
    },
    series: []
};

var CHART_OPTIONS_MAP = {
    BARCHART: {
        plotOptions: {
            column: {
                pointPadding: 0.2,
                borderWidth: 0,
                colorByPoint: true
            }
        },
        tooltip: {
            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                    '<td style="padding:0"><b>{point.y:.1f}</b></td></tr>',
            footerFormat: '</table>',
            shared: true,
            useHTML: true
        },
        xAxis: {
            categories: [],
            crosshair: true
        },
        yAxis: {
            min: 0
        },
        subtitle: {}
    },
    PIECHART: {
        plotOptions: {
            pie: {
                allowPointSelect: false,
                dataLabels: {
                    enabled: false,
                    format: '{point.percentage:.1f} %   ( {point.y} )<br><b>{point.name}</b>',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black',
                        overflow: "hidden",
                        whiteSpace: "nowrap",
                        textOverflow: "ellipsis",
                        width: "100px",
                        fontSize: "8px"
                    }
                },
                showInLegend: true
            }
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}% ( {point.y:.1f} )</b> '
        },
        subtitle: {}
    },
    DONUT: {
        plotOptions: {
            pie: {
                allowPointSelect: false,
                innerSize: '60%',
                size: '100%',
                dataLabels: {
                    enabled: false,
                    format: '{point.percentage:.1f} %   ( {point.y} )<br><b>{point.name}</b>',
                    style: {
                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black',
                        overflow: "hidden",
                        whiteSpace: "nowrap",
                        textOverflow: "ellipsis",
                        width: "100px",
                        fontSize: "8px"
                    }
                }
            }
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}% ( {point.y:.1f} )</b> '
        },
        subtitle: {}
    },
    AREA: {
        plotOptions: {
            area: {
                fillColor: {
                    linearGradient: {
                        x1: 0,
                        y1: 0,
                        x2: 0,
                        y2: 1
                    },
                    stops: [
                        [0, Highcharts.getOptions().colors[0]],
                        [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                    ]
                },
                marker: {
                    radius: 2
                },
                lineWidth: 1,
                states: {
                    hover: {
                        lineWidth: 1
                    }
                },
                threshold: 0
            }
        },
        tooltip: {
//            formatter: function () {
//                return numeral(this.y).format('0.00 b');;
//            }
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: {
            title: {
                text: ''
            }
        },
        subtitle: {
            text: document.ontouchstart === undefined ?
                    'Click and drag in the plot area to zoom in' : 'Pinch the chart to zoom in'
        }
    },
    LINE: {
        plotOptions: {
            line: {
                fillColor: {
                    linearGradient: {
                        x1: 0,
                        y1: 0,
                        x2: 0,
                        y2: 1
                    },
                    stops: [
                        [0, Highcharts.getOptions().colors[0]],
                        [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                    ]
                },
                marker: {
                    radius: 2
                },
                lineWidth: 1,
                states: {
                    hover: {
                        lineWidth: 1
                    }
                },
                threshold: 0
            }
        },
        tooltip: {
//            formatter: function () {
//                return numeral(this.y).format('0.00 b');;
//            }
        },
        xAxis: {
            type: 'datetime'
        },
        yAxis: {
            title: {
                text: ''
            }
        },
        subtitle: {
            text: document.ontouchstart === undefined ?
                    'Click and drag in the plot area to zoom in' : 'Pinch the chart to zoom in'
        }
    },
    TABLE: {
        plotOptions: {},
        tooltip: {},
        subtitle: {}
    }
};
