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

# System's dependencies
# ==========================================
include_recipe 'build-essential'
include_recipe 'openssl'            if node['generic_nodejs']['config']['install_openssl']
include_recipe 'git'                if node['generic_nodejs']['config']['install_git']
include_recipe 'nodejs'             if node['generic_nodejs']['config']['install_ndoejs']
include_recipe 'couchdb'            if node['generic_nodejs']['config']['install_couchdb']
include_recipe 'redisio'            if node['generic_nodejs']['config']['install_redisio']
include_recipe 'redisio::enable'    if node['generic_nodejs']['config']['install_redisio']
# include_recipe 'iptables'           if node['generic_nodejs']['config']['install_iptables']

# Set ENV
# ==========================================
ENV['NODE_ENV'] = node['generic_nodejs']['NODE_ENV']

bash "NODE_ENV" do
  code <<-EOF
  echo "NODE_ENV=${NODE_ENV}\nexport NODE_ENV" >> /etc/profile.d/node_env.sh
EOF
end

# Default user
# ==========================================
user 'generic_nodejs' do
  home '/usr/local/var/lib/generic_nodejs'
  comment 'generic_nodejs user'
  supports :manage_home => false
  system true
end
