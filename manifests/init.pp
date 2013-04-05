# This class installs tomcat.
#
# === Parameters
#
# Document parameters here.
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
class tomcat ($version = $tomcat::params::version) inherits tomcat::params  {
    
    include concat::setup

    package { ["tomcat${version}", 'libtcnative-1', 'liblog4j1.2-java', 'libcommons-logging-java']: ensure => held, }

    file { [$tomcat::params::root, $tomcat::params::home, '/etc/tomcat.d/',]:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
    }

    file { "/etc/init.d/tomcat":
        source => "puppet:///modules/tomcat/tomcat",
        owner  => 'root',
        group  => 'root',
    }

    file { "/usr/sbin/tomcat":
        ensure => link,
        target => "/etc/init.d/tomcat",
        owner  => 'root',
        group  => 'root',
    }

    service { "tomcat${version}":
        pattern => "/var/lib/tomcat${version}",
        ensure  => stopped,
        enable  => false,
        require => Package["tomcat${version}"],
    }

    profile_d::script { 'CATALINA_HOME.sh':
        ensure  => present,
        content => "export CATALINA_HOME=/usr/share/tomcat${version}",
    }

    profile_d::script { 'CATALINA_BASE.sh':
        ensure  => present,
        content => 'export CATALINA_BASE=$HOME/tomcat',
    }
}