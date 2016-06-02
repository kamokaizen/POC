var TimeFilter = [
    { "label": "12 Hours", "value": 12 },
    { "label": "24 Hours", "value": 24 },
    { "label": "2 Days", "value": 48 },
    { "label": "3 Days", "value": 72 },
    { "label": "5 Days", "value": 120 },
    { "label": "7 Days", "value": 168 }
];

var ReportType = {
    "dashboardOverview": "DASHBOARD_OVERVIEW",
    "dashboardAttacks": "DASHBOARD_ATTACK_SUMMARY",
    "domainOverview": "DOMAIN_OVERVIEW",
    "domainAttacks": "DOMAIN_ATTACK"
}

var GraphTypeMap = {
    "PIECHART": "pie",
    "BARCHART": "column",
    "TABLE": "table",
    "AREA": "area",
    "DONUT": "pie",
    "LINE": "line"
};

// base 00: #1B2B34
// base 01: #343D46
// base 02: #4F5B66
// base 03: #65737E
// base 04: #A7ADBA
// base 05: #C0C5CE
// base 06: #CDD3DE
// base 07: #D8DEE9
// base 08: #EC5f67
// base 09: #F99157
// base 0A: #FAC863
// base 0B: #99C794
// base 0C: #5FB3B3
// base 0D: #6699CC
// base 0E: #C594C5
// base 0F: #AB7967

var LegendMap = {
    "Malware" : "#EC5f67",
    "Phishing" : "#F99157",
    "Blacklist" : "#FAC863",
    "Iframe Injection" : "#99C794",
    "Code Injection" : "#5FB3B3",
    "XSS" : "#6699CC",
    "CSRF" : "#A67766",
    "Drive by Download" : "#C594C5",
    "Trojan" : "#7367AB",
    "Backdoor" : "#65737E",
    "Other" : "#CDD3DE"
}

var ThreatLevels = {
    "S" : {
        "class" : "label-safe",
        "label" : "Safe"
    },
    "L" : {
        "class" : "label-low",
        "label" : "Low"
    },
    "M" : {
        "class" : "label-medium",
        "label" : "Medium"
    },
    "H" : {
        "class" : "label-high",
        "label" : "High"
    },
    "VH" : {
        "class" : "label-very-high",
        "label" : "Very High"
    },
    "C" : {
        "class" : "label-critic",
        "label" : "Critical"
    }
}

var ClusterStyles = [
    {
        textColor: 'white',
        url: '/assets/images/map/m1.png',
        height: 50,
        width: 50,
        textSize: 10
    },
    {
        textColor: 'white',
        url: '/assets/images/map/m2.png',
        height: 60,
        width: 60,
        textSize: 11
    },
    {
        textColor: 'white',
        url: '/assets/images/map/m3.png',
        height: 70,
        width: 70,
        textSize: 12
    },
    {
        textColor: 'white',
        url: '/assets/images/map/m4.png',
        height: 80,
        width: 80,
        textSize: 13
    },
    {
        textColor: 'white',
        url: '/assets/images/map/m5.png',
        height: 90,
        width: 90,
        textSize: 14
    }
];

var MapStyle = [{ "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#e9e9e9" }, { "lightness": 17 }] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [{ "color": "#f5f5f5" }, { "lightness": 20 }] }, { "featureType": "road.highway", "elementType": "geometry.fill", "stylers": [{ "color": "#ffffff" }, { "lightness": 17 }] }, { "featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{ "color": "#ffffff" }, { "lightness": 29 }, { "weight": 0.2 }] }, { "featureType": "road.arterial", "elementType": "geometry", "stylers": [{ "color": "#ffffff" }, { "lightness": 18 }] }, { "featureType": "road.local", "elementType": "geometry", "stylers": [{ "color": "#ffffff" }, { "lightness": 16 }] }, { "featureType": "poi", "elementType": "geometry", "stylers": [{ "color": "#f5f5f5" }, { "lightness": 21 }] }, { "featureType": "poi.park", "elementType": "geometry", "stylers": [{ "color": "#dedede" }, { "lightness": 21 }] }, { "elementType": "labels.text.stroke", "stylers": [{ "visibility": "on" }, { "color": "#ffffff" }, { "lightness": 16 }] }, { "elementType": "labels.text.fill", "stylers": [{ "saturation": 36 }, { "color": "#333333" }, { "lightness": 40 }] }, { "elementType": "labels.icon", "stylers": [{ "visibility": "off" }] }, { "featureType": "transit", "elementType": "geometry", "stylers": [{ "color": "#f2f2f2" }, { "lightness": 19 }] }, { "featureType": "administrative", "elementType": "geometry.fill", "stylers": [{ "color": "#fefefe" }, { "lightness": 20 }] }, { "featureType": "administrative", "elementType": "geometry.stroke", "stylers": [{ "color": "#fefefe" }, { "lightness": 17 }, { "weight": 1.2 }] }];

function NFormatter(num) {
    if (num >= 1000000000) {
        return String((num / 1000000000).toFixed(1).replace(/\.0$/, '') + 'G');
    }
    if (num >= 1000000) {
        return String((num / 1000000).toFixed(1).replace(/\.0$/, '') + 'M');
    }
    if (num >= 1000) {
        return String((num / 1000).toFixed(1).replace(/\.0$/, '') + 'K');
    }
    return String(num);
}