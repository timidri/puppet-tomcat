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
#   ip_address    = 'fe80::1%lo0',
#   http_port     = '8081',
#   https_port    = '8444',
#   ajp_port      = '8010',
#   shutdown_port = '8006',
#   scheme        = 'http',
#   apr_enabled   = true,
#   max_heap      = '2048m',
#   min_heap      = '1024m',
#   min_perm      = '384m',
#   max_perm      = '512m',
#   unpack_wars   = false,
#   auto_deploy   = true,
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

    tomcat::jndi { $name: }

    tomcat::realm { $name: }

    tomcat::valve { $name: }

    tomcat::cluster { $name: }

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
    }

    file { "${instance_home}/tomcat/bin/bootstrap.jar":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/bootstrap.jar",
    }

    file { "${instance_home}/tomcat/bin/catalina.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/catalina.sh",
    }

    file { "${instance_home}/tomcat/bin/digest.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/digest.sh",
    }

    file { "${instance_home}/tomcat/bin/setclasspath.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/setclasspath.sh",
    }

    file { "${instance_home}/tomcat/bin/shutdown.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/shutdown.sh",
    }

    file { "${instance_home}/tomcat/bin/startup.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/startup.sh",
    }

    file { "${instance_home}/tomcat/bin/tool-wrapper.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/tool-wrapper.sh",
    }

    file { "${instance_home}/tomcat/bin/version.sh":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/version.sh",
    }

    file { "${instance_home}/tomcat/conf/catalina.properties":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/catalina.properties",
    }

    file { "${instance_home}/tomcat/conf/context.xml":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/context.xml",
    }

    file { "${instance_home}/tomcat/conf/logging.properties":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/logging.properties",
    }

    file { "${instance_home}/tomcat/conf/policy.d":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/policy.d",
    }

    file { "${instance_home}/tomcat/conf/tomcat-users.xml":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/tomcat-users.xml",
    }

    file { "${instance_home}/tomcat/conf/web.xml":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/web.xml",
    }

    file { "${instance_home}/tomcat/lib/log4j.jar":
        ensure => link,
        target => "/usr/share/java/log4j-1.2.jar",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/lib/commons-logging.jar":
        ensure => link,
        target => "/usr/share/java/commons-logging.jar",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/lib/log4j.properties": content => template('tomcat/log4j.properties.erb'), }

    file { "${instance_home}/tomcat/bin/setenv.sh": content => template('tomcat/setenv.sh.erb'), }

    user { $name:
        home     => $instance_home,
        password => '!',
        ensure   => $ensure,
        comment  => "${name} instance user",
        require  => File[$tomcat::params::home],
    }

    file { "/etc/tomcat.d/${name}":
        ensure  => $ensure,
        content => "",
        require => User[$name],
    }

    file { "${instance_home}/tomcat/conf/server.xml":
        owner   => $name,
        group   => $name,
        content => template("tomcat/server.xml.erb"),
        require => File["${instance_home}/tomcat"],
        notify  => Tomcat::Service[$name],
    }
}
