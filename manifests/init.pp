# == Class: wp_wrapper
#
# Full description of class wp_wrapper here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { wp_wrapper:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class wp_wrapper(
  $wp_db_pw,
  $wp_db_user     = 'wordpress',
  $wp_install_url = 'http://192.168.122.1',
  $version        = '3.8.5'
) {

  mysql::db { 'wordpress':                                                         
    user     => $wp_db_user,                                                       
    password => $wp_db_pw,                                                         
    host     => 'localhost',                                                       
    grant    => ['ALL'],                                                           
  }                                                                                
                                                                                   
  class { 'wordpress':                                                             
    db_user        => $wp_db_user,                                                 
    db_password    => $wp_db_pw,                                                   
    install_url    => $wp_install_url,                                             
    version        => $wp_version,                                                 
    create_db      => false,                                                       
    create_db_user => false,                                                       
    install_dir    => '/var/www/html/wp',                                          
    require        => Mysql::Db['wordpress'],                                      
  }                                                                                
                                                                                   
  class { '::mysql::bindings':                                                     
    php_enable => true,                                                            
    require    => Mysql::Db['wordpress'],
  }                                                                                
                                                                                   
  class { '::apache':                                                              
    require => Class['::mysql::bindings'],
  }                                                                                
                                                                                   
  include ::apache::mod::php

}
