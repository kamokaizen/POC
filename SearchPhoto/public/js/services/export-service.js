angular.module('customerportal').factory('ExportService', function ($resource, $timeout, poller, CallService, inform) {

    var exportService = {};
    var reportData = {};
    var reportType = '';
    var reportName = 'Report Name';
    var partnerName = 'Partner Name';
    var selectedFilterTime = "";
    var informObj = null;
    var POLLER_DELAY = 3000;
    var POLLER_TIMEOUT = 180000;
    var pollerTimeout = null;
    var timeoutExceed = false;

    exportService.notify = function (duration, type, msg) {
        informObj = inform.add(msg, {
            ttl: duration, type: type
        });
    };

    exportService.selectedFilterTime = function (time) {
        selectedFilterTime = time;
    };

    exportService.reportName = function (nameOfReport) {
        reportName = nameOfReport;
    };

    exportService.partnerName = function (nameOfPartner) {
        partnerName = nameOfPartner;
    };

    exportService.reportType = function (type) {
        reportType = type;
    };

    exportService.reportData = function (data) {
        reportData = data;
    };

    exportService.exportPage = function () {

        var sendData = {};
        var currTime = new Date().getTime();
        sendData.fromTime = currTime - (selectedFilterTime * 60 * 60 * 1000);
        sendData.toTime = currTime;
        sendData.reportData = reportData;
        sendData.reportType = reportType;
        sendData.reportName = reportName;
        sendData.partnerName = partnerName;

        CallService.post("/api/report/generate", sendData, function (err, data) {
            var msg = "";
            if (err) {
                //Handle error
                msg = "Exporting has been failed. Please try again..";
                inform.remove(informObj);
                exportService.notify(4000, 'danger', msg);
            } else {
                if (data.status) {
                     msg = "Exporting has been started. Please wait..";
                    inform.remove(informObj);
                    exportService.notify(2000, 'info', msg);
                    var id = data.message;
                    console.log("id=" + id);
                    exportService.setPoller(id);
                }
                else {
                     msg = "Exporting has been failed. Please try again..";
                    inform.remove(informObj);
                    exportService.notify(4000, 'danger', msg);
                }
            }
        });
    };

    exportService.setPoller = function (reportId) {
        var resource = $resource("/api/report/status/" + reportId);

        var thisPoller = poller.get(resource, { delay: POLLER_DELAY });

        pollerTimeout = $timeout(function () { timeoutExceed = true; }, POLLER_TIMEOUT);

        thisPoller.promise.then(null, null, function (result) {
            var msg = "";
            if (timeoutExceed) {
                timeoutExceed = false;
                $timeout.cancel(pollerTimeout);
                thisPoller.stop();
                 msg = "Timeout has exceeded. Please try again..";
                inform.remove(informObj);
                exportService.notify(4000, 'danger', msg);
            }

            //Successfully resolved
            if (result.$resolved) {
                if (result.message === "FAILED") {
                    thisPoller.stop();
                    $timeout.cancel(pollerTimeout);
                     msg = "Exporting has been failed. Please try again..";
                    inform.remove(informObj);
                    exportService.notify(4000, 'danger', msg);
                }
                else if (result.message === "SUCCESS") {
                    thisPoller.stop();
                    $timeout.cancel(pollerTimeout);
                     msg = "Exporting has just finished. PDF is being downloaded..";
                    inform.remove(informObj);
                    exportService.notify(3000, 'success', msg);
                    exportService.downloadReport(reportId);
                }
            } else {
                // Error handler: (data, status, headers, config)
                poller.stopAll();
                $timeout.cancel(pollerTimeout);
                 msg = "Exporting has been failed. Please try again..";
                inform.remove(informObj);
                exportService.notify(4000, 'danger', msg);
            }
        });
    };

    exportService.downloadReport = function (reportId) {
        CallService.download("/api/report/download/" + reportId, {}, function (err, data) {
            if (err) {
                console.log("Something went wrong on downloading report id: " + reportId);
                console.log("Error : " + err);
                // Handle error
            } else {
                var b64toBlob = function(b64Data, contentType, sliceSize) {
                    contentType = contentType || '';
                    sliceSize = sliceSize || 512;

                    var byteCharacters = atob(b64Data);
                    var byteArrays = [];

                    for (var offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                        var slice = byteCharacters.slice(offset, offset + sliceSize);

                        var byteNumbers = new Array(slice.length);
                        for (var i = 0; i < slice.length; i++) {
                            byteNumbers[i] = slice.charCodeAt(i);
                        }

                        var byteArray = new Uint8Array(byteNumbers);

                        byteArrays.push(byteArray);
                    }

                    var blob = new Blob(byteArrays, { type: contentType });
                    return blob;
                };

                var download = function(url, name) {
                    var a = document.createElement('a');
                    a.href = url;
                    a.download = name;
                    document.body.appendChild(a);
                    a.click();
                    a.remove();
                };

                var blob = b64toBlob(data.content, "application/pdf");
                var blobUrl = URL.createObjectURL(blob);
                download(blobUrl, reportId + ".pdf");
            }
        });
    };

    return exportService;
});