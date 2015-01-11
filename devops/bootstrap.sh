#!/bin/bash
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


# Example
# ./bootstrap ENVIRONMENT SSH_KEY

# ------------------------------------------
# Enviroment Values
# ------------------------------------------
# $1                # ENVIRONMENT Name,     Set by User shell
# $2                # SSH_KEY,              Set by User shell

# ------------------------------------------
# SET Service Values
# ------------------------------------------
: ${NODE_ENV=${1}}
: ${SSH_KEY=${10}}

# ------------------------------------------
# Export
# ------------------------------------------
export NODE_ENV;                echo "export NODE_ENV="${NODE_ENV} >> /etc/bashrc

source /etc/bashrc

# ------------------------------------------
# Vital dependencies
# ------------------------------------------
yum install -y gcc gcc-c++ make
yum install -y openssl
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils-MakeMaker
yum groupinstall -y 'Development Tools'
yum remove -y git

# ------------------------------------------
# SSH Keys injection
# ------------------------------------------
if [ -f ${SSH_KEY} ]; then
    eval `ssh-agent -s`
    ssh-add ${SSH_KEY}
    if [ -f ${SSH_KEY}'.pub' ]; then
        cat ${SSH_KEY}'.pub' | cat >> ~/.ssh/authorized_keys
    fi
    ssh-add -l

fi

# ------------------------------------------
# Setup git 1.9.4
# ------------------------------------------
cd ~ && \
wget https://www.kernel.org/pub/software/scm/git/git-1.9.4.tar.gz && \
tar xzf git-1.9.4.tar.gz

cd git-1.9.4 && \
make prefix=/usr/local/git all && \
make prefix=/usr/local/git install && \
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc && \
source /etc/bashrc

git config --global http.sslVerify false

# ------------------------------------------
# Setup node & npm
# ------------------------------------------
curl -sL https://rpm.nodesource.com/setup | bash -
yum install -y nodejs

cd /vagrant

# ------------------------------------------
# Setup node & pm2
# ------------------------------------------
npm install pm2 -g
npm install nodemon -g
npm install express -g


# ------------------------------------------
# Setup the app
# ------------------------------------------
# TODO

# ------------------------------------------
# Completion
# ------------------------------------------
echo Done.

