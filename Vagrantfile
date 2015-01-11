# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# ==========================================
# The MIT License (MIT)
# Copyright (c) 2015 Evangelos Pappas
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ==========================================

# ==========================================
# MAIN Requirements & configurations
# ==========================================
require 'fileutils'
require 'etc'

Vagrant.require_version ">= 1.6.0"

CONFIG = File.join(File.dirname(__FILE__), "./devops/Vagrant-config.rb")
VAGRANTFILE_API_VERSION = "2"

$ENVIRONMENTS     = ['development'] #, 'test', 'production']
$DOMAIN           = 'local'

$num_instances    = $ENVIRONMENTS.length
$vb_gui           = false
$vb_memory        = 1024
$vb_cpus          = 1
$key              = ''
$key_pub          = ''
$keyBaseName      = ''
$user             = Etc.getlogin

rsa_key = File.expand_path('~') + '/.ssh/id_rsa'
dsa_key = File.expand_path('~') + '/.ssh/id_dsa'

# Vagrant Nodes
# ==========================================
nodes = [
    { :hostname => 'experimental',  :ip => '192.168.1.5', :box => 'trusty64', :box_url => '"https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box'}
]

# Key Finder
# ==========================================
if File.exists?(rsa_key)
  $key          = rsa_key
  $key_pub      = rsa_key + '.pub'
  $keyBaseName  = File.basename($key)
elsif  File.exists?(dsa_key)
  $key          = dsa_key
  $key_pub      = rsa_key + '.pub'
  $keyBaseName  = File.basename($key)
end

# Config Injection
# ==========================================
if File.exist?(CONFIG)
  require CONFIG
end

# ==========================================
# MAIN
# ==========================================
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # ==========================================
  # Spin for each node in each environment
  # ==========================================
  nodes.each do |node|
    (0..($num_instances-1)).each do |i|
      config.vm.define vm_name = "%s.%s" % [node[:hostname], $ENVIRONMENTS[i]] do |node_config|

        # Set the box
        # ==========================================
        node_config.vm.box        = "trusty64"
        node_config.vm.box_url    = "https://vagrantcloud.com/ubuntu/boxes/trusty64/versions/14.04/providers/virtualbox.box"
        node_config.vm.hostname   = "%s.%s" % [vm_name, $DOMAIN]

        # virtualbox configs
        # ==========================================
        node_config.vm.provider :virtualbox do |v|
          v.check_guest_additions = false
          v.functional_vboxsf     = false
          v.gui                   = $vb_gui
          v.memory                = $vb_memory
          v.cpus                  = $vb_cpus
        end

        # plugin conflict
        # ==========================================
        if Vagrant.has_plugin?("vagrant-vbguest") then
          node_config.vbguest.auto_update = true
        end

        # network
        # ==========================================
        ip = "%s%s" % [node[:ip], (i + 1)]
        config.vm.network "private_network", :ip => ip

        config.vm.network "forwarded_port", :guest => 80,   :host => 8080, :auto_correct => true
        config.vm.network "forwarded_port", :guest => 5984, :host => 5984, :auto_correct => true

        # ssh
        # ==========================================
        node_config.ssh.forward_agent = true

        # Copy over my keys
        # ==========================================
        if $key
          unless File.exist?("./devops/%s" % node[:hostname])
            FileUtils.mkdir_p("./devops/%s/.ssh" % node[:hostname])
          end

          FileUtils.cp($key, "./devops/%s/.ssh/%s" % [node[:hostname], $keyBaseName])
          FileUtils.cp($key_pub, "./devops/%s/.ssh/%s" % [node[:hostname], $keyBaseName + '.pub'])
        end

        # Docker
        # ==========================================
        # node_config.vm.provision "docker", :images => ["ubuntu", "shykes/couchdb", "redis", "coreos/etcd", "dockerfile/haproxy"]
        #
        # # Docker - couchdb
        # # ==========================================
        # node_config.vm.provision "docker" do |d|
        #   d.run "couchdb", :image => "shykes/couchdb", :args => "-d -p 5984:5984"
        # end
        #
        # # Docker - redis
        # # ==========================================
        # node_config.vm.provision "docker" do |d|
        #   d.run "redis", :image => "redis", :args => "-d -p 6379:6379 -p 26379:26379"
        # end

        # Syncs
        # ==========================================
        node_config.vm.synced_folder "./devops",      "/app/devops",        :id => "vagrant-devops",         :nfs => true
        node_config.vm.synced_folder "./app",         "/app/node",          :id => "vagrant-node",           :nfs => true

        # Chef Provisioner
        # ==========================================
        # config.berkshelf.enabled = true
        # config.berkshelf.berksfile_path = "./devops/chef-repo/Berksfile"
        # config.berkshelf.args = []
        config.vm.provision "chef_solo" do |chef|
          chef.node_name          = "govdata"
          chef.provisioning_path  = "/tmp/vagrant-chef"
          chef.cookbooks_path     = ["./devops/chef-repo/vendor-cookbooks", "./devops/chef-repo/cookbooks"]
          chef.roles_path         = "./devops/chef-repo/roles"
          chef.data_bags_path     = "./devops/chef-repo/data_bags"
          chef.environments_path  = "./devops/chef-repo/environments"
          chef.environment        = $ENVIRONMENTS[i]
          chef.synced_folder_type = "nfs"

          chef.add_role           "generic_nodejs"
        end
      end # config.vm.define
    end # $num_instances loop
  end # nodes loop
end # of main
