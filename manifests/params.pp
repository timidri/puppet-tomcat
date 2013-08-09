# == Class: tomcat::params
#
# This class manages Tomcat parameters.
#
# === Parameters
#
# === Variables
#
# === Examples
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
class tomcat::params {
    $root               = '/opt/tomcat'
    $home               = "${root}/sites"
    $package_name       = 'tomcat7'
    $package_version    = 7
    $version            = '7.0.42'
    $installmethod      = 'package'
    $installroot        = "/usr/share"
    $support_packages   =  $operatingsystem ? {
        /CentOS|RedHat/ => undef,
        /Debian|Ubuntu/ => [ 'libtcnative-1', 'liblog4j1.2-java', 'libcommons-logging-java'],
        default         => undef,
    }
}