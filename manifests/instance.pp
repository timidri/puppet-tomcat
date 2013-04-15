# This resource installs a tomcat instance.
#
# === Parameters
#
# Document parameters here.
#
# [*ip_address*]    The ipv4 /ipv6 ipadress the http connector should use. Defaults to all.
# [*http_port*]     The port the http connector should use. Defaults to 8080.
# [*https_port*]    The port the https connector should use. Defaults to 8443.
# [*ajp_port*]      The port the ajp connector should use. Defaults to 8009.
# [*shutdown_port*] The port the shutdown command can be issued to. Defaults to 8005.
# [*scheme*]        The scheme the http connector should use. Defaults to http.
# [*apr_enabled*]   Enable apr. Defaults to true.
# [*max_heap*]      Max heap space to use. Defaults to 1024m.
# [*min_heap*]      Min heap space to use. Defaults to 1024m.
# [*min_perm*]      Min permgen space. Defaults to 384m.
# [*max_perm*]      Max permgen space. Defaults to 384m.
# [*unpack_wars*]   Unpack wars. Defaults to true.
# [*auto_deploy*]   Auto deploy wars. Defaults to true.
#
# === Variables
#
# === Examples
#
#  tomcat::instance { 'instance_1':
#   ip_address    => 'fe80::1%lo0',
#   http_port     => '8081',
#   https_port    => '8444',
#   ajp_port      => '8010',
#   shutdown_port => '8006',
#   scheme        => 'http',
#   apr_enabled   => true,
#   max_heap      => '2048m',
#   min_heap      => '1024m',
#   min_perm      => '384m',
#   max_perm      => '512m',
#   unpack_wars   => false,
#   auto_deploy   => true,
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
define tomcat::instance (
    $ip_address    = undef,
    $http_port     = '8080',
    $https_port    = '8443',
    $ajp_port      = '8009',
    $shutdown_port = '8005',
    $scheme        = 'http',
    $apr_enabled   = true,
    $max_heap      = '1024m',
    $min_heap      = '1024m',
    $min_perm      = '384m',
    $max_perm      = '384m',
    $unpack_wars   = true,
    $auto_deploy   = true,
    $ensure        = present,) {
    include tomcat

    $instance_home = "${tomcat::params::home}/${name}"

    tomcat::service { $name: }

    tomcat::jndi { $name: notify => Tomcat::Service[$name], }

    tomcat::realm { $name: notify => Tomcat::Service[$name], }

    tomcat::valve { $name: notify => Tomcat::Service[$name], }

    tomcat::cluster { $name: notify => Tomcat::Service[$name], }

    file { [
        $instance_home,
        "${instance_home}/tomcat",
        "${instance_home}/tomcat/bin",
        "${instance_home}/tomcat/conf",
        "${instance_home}/tomcat/conf/Catalina",
        "${instance_home}/tomcat/conf/Catalina/localhost",
        "${instance_home}/tomcat/lib",
        "${instance_home}/tomcat/logs",
        "${instance_home}/tomcat/temp",
        "${instance_home}/tomcat/webapps",
        "${instance_home}/tomcat/work"]:
        ensure  => directory,
        owner   => $name,
        group   => $name,
        require => User[$name],
        notify  => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/bootstrap.jar":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/bootstrap.jar",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/catalina.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/catalina.sh",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/digest.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/digest.sh",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/setclasspath.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/setclasspath.sh",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/shutdown.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/shutdown.sh",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/startup.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/startup.sh",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/tool-wrapper.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/tool-wrapper.sh",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/version.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/version.sh",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/conf/catalina.properties":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/catalina.properties",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/conf/logging.properties":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/logging.properties",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/conf/policy.d":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/policy.d",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/conf/tomcat-users.xml":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/tomcat-users.xml",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/conf/web.xml":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/web.xml",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/setenv.sh":
        content => template('tomcat/setenv.sh.erb'),
        notify  => Tomcat::Service[$name],
    }

    user { $name:
        ensure   => $ensure,
        home     => $instance_home,
        password => '!',
        comment  => "${name} instance user",
        require  => File[$tomcat::params::home],
        notify   => Tomcat::Service[$name],
    }

    file { "/etc/tomcat.d/${name}":
        ensure  => $ensure,
        content => '',
        require => User[$name],
        notify  => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/conf/server.xml":
        owner   => $name,
        group   => $name,
        content => template('tomcat/server.xml.erb'),
        require => File["${instance_home}/tomcat"],
        notify  => Tomcat::Service[$name],
    }
    
    file { "${instance_home}/tomcat/conf/context.xml":
        owner   => $name,
        group   => $name,
        content => template('tomcat/context.xml.erb'),
        require => File["${instance_home}/tomcat"],
        notify  => Tomcat::Service[$name],
    }
}