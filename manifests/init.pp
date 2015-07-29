# == Class: wp_wrapper
#
# Wrapper class for wordpress and MySQL modules
#
# === Parameters
#
# [*wp_db_pw*]
#   Database password that Wordpress will use; database will be setup with this
#   password automatically.
#
# [*wp_db_user*]
#   Database user that Wordpress will use; database will be setup with this
#   user automatically. Defaults to 'wordpress'.
#
# [*wp_install_url*]
#   URL to download the software from; defaults to project homepage.
#
# [*wp_version*]
#   Version of Wordpress to install; defaults to latest upstream 4.2.3
#
# === Examples
#
#  class { wp_wrapper:
#    wp_db_pw       => 'weirdpassword',
#    wp_db_user     => 'databaseuser',
#    wp_install_url => 'http://internal.server.com/pub',
#    wp_version     => '3.8.5',
#  }
#
# === Authors
#
# Maxim Burgerhout <maxim@redhat.com>
#
# === Copyright
#
# Copyright 2015 Maxim Burgerhout
#
class wp_wrapper(
  $wp_db_pw,
  $wp_db_user     = 'wordpress',
  $wp_install_url = 'http://wordpress.org',
  $wp_version     = '4.2.3'
) {

  class { '::mysql::server':}

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

  firewalld::zone { 'public':
    description => 'Public zone, custom for wordpress',
    services    => ['ssh', 'dhcpv6-client', 'http',],
  }


}
