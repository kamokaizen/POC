var logHelper = require('./utils/log-helper');
logHelper.initializeLogger('./log', './config/log4js.json');
var log  = logHelper.getLogger('app');
var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var helmet = require("helmet");
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

if (process.env.SEARCH_PHOTO_ENV) {
    global.conf = require('./config/config.' + process.env.SEARCH_PHOTO_ENV + '.json');
    log.info("Configuration is set for " + process.env.SEARCH_PHOTO_ENV);
} else {
    throw new Error("No Configuration is found. Application will be shut down!");
}

if (!global.conf.listenPort) {
    throw new Error("Listen port is not defined!. Please add listen port to config!");
}

var app = express();

// uncomment after placing your favicon in /public
app.use(express.static(__dirname + "/public"));
app.use(favicon(path.join(__dirname, 'public/assets/images', 'favicon.ico')));
app.use(logHelper.getHttpLogger());
app.use(bodyParser.json({ limit: '10mb' }));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());

app.use(helmet());

app.listen(global.conf.listenPort);
log.info("SearchPhoto is listening on port " + global.conf.listenPort);
log.info("SearchPhoto started at " + new Date());

module.exports = app;
