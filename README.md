exoscale-wordpress
==================

A wordpress environment to deploy on [exoscale](http://www.exoscale.ch/open-cloud/compute/) or any cloud-init compatible cloud with plain vanilla Ubuntu instances.

## Principles:

This cookbook will leverage userdata extensibility of CloudStack and the features of cloud-init to 
bootstrap a fully fonctionnal Wordpress install which IS NOT a clone.

* Userdata will be filled with a script
* Script will be called on first boot by cloud-init
* A puppet repository will be pulled on the instance
* The script will launch Puppet and apply the manifest and eventually after PHP, NGINX and MYSQL installation pull a fresh copy of Wordpress and install it.

Keep it mind that it is possible to go much further in automation deployment.

## Usage guide:

### Start an instance

Launch a new Ubuntu instance with the service offering you wish. Insert it in a security group or with firewall rules which enable port 80/http.

### User Data with Cloud-init

In the User Data tab, input the script below:

    #!/bin/sh
    set -e -x

    apt-get --yes --quiet update
    apt-get --yes --quiet install git puppet-common

    #
    # Fetch puppet configuration from public git repository.
    #

    mv /etc/puppet /etc/puppet.orig
    git clone https://github.com/exoscale/exoscale-wordpress.git /etc/puppet

    #
    # Run puppet.
    #

    puppet apply /etc/puppet/manifests/init.pp

### Start using your fresh  Wordpres

Point your browser to your instance public IP address and you should be asked for an admin email and password. 

### Advanced usage

For anything other than testing, we recommend forking this repository and modify the config/common.csv file with your details.
Of course also alter the git clone argument passed to your instance via user-data to match your personal repository.

## Modify:

To modify your configuration, clone this very repository and adjust files and manifests accordingly. 
Do not forget to replace the URL in the userdata script.

## TODO

* Salt wp-config.php
* Better mysql DB security

## Credits:

this is inspired by the work of [chadthompson]: http://chadthompson.me on https://github.com/chad-thompson/vagrantpress
