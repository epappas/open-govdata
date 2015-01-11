/********************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2015 Evangelos Pappas
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
/********************************************/

'use strict';

// ==========================================
// Dependencies
// ==========================================
var bunyan          = require('bunyan');
var restify         = require('restify');
var responseTime    = require('response-time');
var winston         = require('winston');
var os              = require('os');
var pjson           = require('./package.json');

// ==========================================
// Conf
// ==========================================
var conf = require('./config/' + process.env.NODE_ENV || 'development');

// ==========================================
// DB Traits
// ==========================================
var redisTrait = require('./modules/redis')(conf);

// ==========================================
// Global redis instance
// ==========================================
var redis = redisTrait.redis;

// ==========================================
// Loggers
// ==========================================
var logger = bunyan.createLogger({name: 'audit'});
var trackLogger = new (winston.Logger)({
    transports: [
        new (winston.transports.Console)(),
        new (winston.transports.File)({ filename: conf.get('log.file') })
    ]
});
trackLogger.transports.console.level    = conf.get('log.level');
trackLogger.transports.file.level       = conf.get('log.level');

// ==========================================
// HTTP Server
// ==========================================
var server = restify.createServer({
    name: 'api-joblist',
    log: logger,
    version: conf.get('version')
});

// ==========================================
// Initialize Models' injection
// ==========================================
var models = {
    user: require('./models/user')(redis, conf)
};

// ==========================================
// MiddleWares' waterfall
// ==========================================
server.use(restify.acceptParser(server.acceptable));
server.use(restify.authorizationParser());
server.use(restify.CORS({
    credentials: true
}));
server.use(restify.queryParser());
server.use(restify.jsonp());
server.use(restify.bodyParser({
    mapParams: true,
    mapFiles: false,
    overrideParams: true,
    keepExtensions: false
}));
server.use(responseTime(0));
server.use(restify.requestLogger());
server.use(restify.throttle({
    burst: 100,
    rate: 50,
    ip: true,
    overrides: {
        '127.0.0.1': {
            rate: 0, // unlimited
            burst: 0
        }
    }
}));
// Default Headers
server.use(function (req, res, next) {
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTIONS');
    res.header('Allow', 'GET,PUT,POST,DELETE,OPTIONS');
    res.header('X-Powered-By', server.name);
    res.header('X-Request-ID', req.id());
    res.header('X-API-Version', pjson.version);
    res.header('Server', os.hostname());
    next();
});

// ==========================================
// Routes' bootstrap
// ==========================================
require('./routes/api')(server, models, redis, conf);

// ==========================================
// Req tracker
// ==========================================
require('./modules/reqtracker')(server, trackLogger, conf);

// ==========================================
// Server's bootstrap
// ==========================================
server.listen(conf.get('port'), function () {
    console.log('%s %s %s listening at %s, PID %s',
        server.name, pjson.version,
        process.env.NODE_ENV,
        server.url, process.pid);
});