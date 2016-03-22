var async = require('async');
var request = require('request');
var fs = require('fs');

exports.start = function() {
    start();
}

var q = async.queue(function(task, cb) {
    request
        .get(task.PdfURL)
        .on('response', function(response) {
            console.log(task.target + " is downloading from: " + task.PdfURL + ' : ' + response.statusCode, response.headers['content-type']);
        })
        .on('error', function(err) {
            console.log(err);
            cb(err);
        })
        .on('end', function() {
            // the call to `cb` could instead be made on the file stream's `finish` event
            // if you want to wait until it all gets flushed to disk before consuming the
            // next task in the queue
            cb();
        })
        .pipe(fs.createWriteStream(task.target));
}, 10);

q.drain = function() {
    console.log('Done.')
};

function start() {
    var pdfs = [{ target: "1.pdf", PdfURL: 'http://www.iso.org/iso/annual_report_2009.pdf' },
        { target: "2.pdf", PdfURL: 'http://www.iso.org/iso/annual_report_2009.pdf' },
        { target: "3.pdf", PdfURL: 'http://www.iso.org/iso/annual_report_2009.pdf' },
        { target: "4.pdf", PdfURL: 'http://www.iso.org/iso/annual_report_2009.pdf' },
        { target: "5.pdf", PdfURL: 'http://www.iso.org/iso/annual_report_2009.pdf' },
        { target: "6.pdf", PdfURL: 'http://www.iso.org/iso/annual_report_2009.pdf' }];

    pdfs.forEach(function(pdf) {
        q.push(pdf, function(err) {
            if (err) {
                console.log(err);
            }
            else{
               console.log(pdf.target + "job is finished"); 
            }
        });
    });
}