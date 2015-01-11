#
# Cookbook Name:: generic_nodejs
# Recipe:: default
#
# The MIT License (MIT)
# 
# Copyright (c) 2015 Evangelos Pappas
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Basics
# ==========================================
default['generic_nodejs']['version']       = '0.0.1-alpha'
default['generic_nodejs']['src_archive']   = "https://github.com/epappas/open-govdata/archive/#{node['generic_nodejs']['version']}.tar.gz"
default['generic_nodejs']['checksum']      = ""

# Config
# ==========================================
default['generic_nodejs']['config']['install_git']      = true
default['generic_nodejs']['config']['install_openssl']  = true
default['generic_nodejs']['config']['install_ndoejs']   = true
default['generic_nodejs']['config']['install_couchdb']  = true
default['generic_nodejs']['config']['install_redisio']  = true
default['generic_nodejs']['config']['install_iptables'] = true
default['generic_nodejs']['config']['log']['level']     = 'info'

# Config - app
# ==========================================
default['generic_nodejs']['config']['app']['cwd']    = '/usr/src'

# Config - httpd
# ==========================================
default['generic_nodejs']['config']['httpd']['bind_address']   = '127.0.0.1'

# Config - CouchDB
# ==========================================
default['generic_nodejs']['config']['couchdb']['port']    = ''
default['generic_nodejs']['config']['couchdb']['host']    = ''

# Config - CouchDB - AUTH
# ==========================================
default['generic_nodejs']['config']['couchdb']['auth_type']       = ''
default['generic_nodejs']['config']['couchdb']['auth_username']   = ''
default['generic_nodejs']['config']['couchdb']['auth_password']   = ''
