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

var redis = require('redis');

var HOST = process.env.REDIS_HOST || 'localhost';
var PORT = process.env.REDIS_PORT || 6379;

/**
 * Redis Trait
 * @param conf
 * @returns {{redis: *, newRedis: newRedis}}
 */
module.exports = function (conf) {
    HOST = conf && conf.get('redis.host') || HOST;
    PORT = conf && conf.get('redis.port') || PORT;

    return {
        redis: redis.createClient(), // a default instance
        newRedis: function newRedis(host, port, options) {
            if (arguments.length === 1 && typeof host === 'object') {
                options = host;
                redis.createClient(HOST, PORT, options);
            }
            if (arguments.lenght > 0) return redis.createClient(host || HOST, port || PORT, options);
            return redis.createClient();
        }
    };
};
