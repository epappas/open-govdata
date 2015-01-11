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

var ctrlBuilder = require('../controllers/api-controller');
var restify = require('restify');

var base_route      = '/';
var status_route    = base_route + '/status';
var ping_route      = base_route + '/ping';

/**
 * Basic API routes
 * @param server
 * @param models
 * @param redis
 * @param conf
 */
module.exports = function (server, models, redis, conf) {
    var controller  = ctrlBuilder(server, models, redis);
    var version     = conf.get('version');

    // ==========================================
    // /status
    // ==========================================
    server.get({path: status_route, version: version}, controller.status);
    server.head({path: status_route, version: version}, controller.status);

    // ==========================================
    // /ping
    // ==========================================
    server.get({path: ping_route, version: version}, controller.ping);
    server.head({path: ping_route, version: version}, controller.ping);
};
