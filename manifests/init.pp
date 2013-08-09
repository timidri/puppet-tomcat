# == Class: Tomcat 
#
# === Parameters
#
# [*version*] The tomcat version to install, defaults to 7.
#
# === Variables
#
# === Examples
#
#  class { tomcat:
#    version  => 6
#  }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
class tomcat (
    $package_name    = $tomcat::params::package_name,
    $root            = $tomcat::params::root,
    $home            = $tomcat::params::home,
    $installmethod   = $tomcat::params::installmethod,
    $installroot     = $tomcat::params::installroot,
    $package_version = $tomcat::params::package_version,
    $version         = $tomcat::params::version,
    $packages        = $tomcat::params::support_packages,
) inherits tomcat::params {
    
    $installpath     = $installmethod ? {
      'package'   => "${installroot}/${package_name}",
      'download'  => "${installroot}/${version}",
      default     => fail("installmethod `${installmethod}' not supported, should be `package' or `download'")
      }
    
    alert($installpath)
    
    include concat::setup

    class { "tomcat::install::${installmethod}":
    }
            
    if $packages != undef {  
        package { $packages:
            ensure => installed,
        }
    }
    
    file { [$tomcat::params::root, $tomcat::params::home, '/etc/tomcat.d/',]:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }

    file { '/etc/init.d/tomcat':
        source => 'puppet:///modules/tomcat/tomcat',
        owner  => 'root',
        group  => 'root',
    }

    file { '/usr/sbin/tomcat':
        ensure => link,
        target => '/etc/init.d/tomcat',
        owner  => 'root',
        group  => 'root',
    }

    service { $package_name:
        ensure  => stopped,
        pattern => 'java.*tomcat.*bootstrap',
        enable  => false,
        require => Class["tomcat::install::${installmethod}"],
    }

    profile_d::script { 'CATALINA_HOME.sh':
        ensure  => present,
        content => "export CATALINA_HOME=${installpath}",
    }

    profile_d::script { 'CATALINA_BASE.sh':
        ensure  => present,
        content => 'export CATALINA_BASE=$HOME/tomcat',
    }
}