# wp_wrapper

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with wp_wrapper](#setup)
    * [What wp_wrapper affects](#what-wp_wrapper-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)

## Overview

This is a very simple Puppet module to setup MySQL (or MariaDB), Apache, and
Wordpress on a RHEL7 or CentOS7 machine. It will also setup some firewall rules
to allow traffic to the new Wordpress site. It uses firewalld for this, hence
the dependency on RHEL7 or CentOS7.

## Module Description

See above. Keep in mind that this module is for demoing, it is not a very well
written piece of software :/

## Setup

### What wp_wrapper affects

This module will install a MySQL or MariaDB server on your machine, install and
configure Apache with a default configuration, open up port 80 in your
firewall, download the Wordpress tarball from wordpress.org and set that up for
you.

It uses the puppetlabs-mysql, puppetlabs-apache, hunner-wordpress and
jpopelka-firewalld modules for this.

## Usage

The module only has one class, 'wp_wrapper', with one required parameter for
the MySQL / MariaDB password (and three more optional ones). Invoke as follows:

class { wp_wrapper:
  wp_db_pw       => 'weirdpassword',
  wp_db_user     => 'databaseuser',
  wp_install_url => 'http://internal.server.com/pub',
  wp_version     => '3.8.5',
}

## Limitations

Only works on RHEL7 and derivates because of the use of firewalld.
