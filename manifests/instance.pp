# This resource installs a tomcat instance.
#
# === Parameters
#
# Document parameters here.
#
# [*shutdown_port*] The port the shutdown command can be issued to. Defaults to 8005.
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
#   shutdown_port => '8006',
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
    $shutdown_port     = 8005,
    $apr_enabled       = true,
    $jmx_enabled       = false,
    $jmx_port          = 8050,
    $jmx_ssl           = false,
    $jmx_authenticate  = false,
    $max_heap          = '1024m',
    $min_heap          = '1024m',
    $min_perm          = '384m',
    $max_perm          = '384m',
    $unpack_wars       = true,
    $auto_deploy       = true,
    $deploy_on_startup = true,
    $ensure            = present,) {
    include tomcat

    $instance_home = "${tomcat::params::home}/${name}"

    tomcat::service { $name:
        ensure => $ensure ? {
            present => 'running',
            absent  => 'stopped',
            default => 'running',
        }
    }

    tomcat::connector::init { $name:
        ensure => $ensure,
        notify => Tomcat::Service[$name],
    }

    tomcat::listener::init { $name:
        ensure => $ensure,
        notify => Tomcat::Service[$name],
    }

    tomcat::jndi::init { $name:
        ensure => $ensure,
        notify => Tomcat::Service[$name],
    }

    tomcat::realm::init { $name:
        ensure => $ensure,
        notify => Tomcat::Service[$name],
    }

    tomcat::valve::init { $name:
        ensure => $ensure,
        notify => Tomcat::Service[$name],
    }

    tomcat::cluster::init { $name:
        ensure => $ensure,
        notify => Tomcat::Service[$name],
    }

    if (!defined(Tomcat::Connector[$name])) {
        tomcat::connector::http { $name: ensure => $ensure, }
    }

    if ($apr_enabled) {
        tomcat::listener { "${name}:org.apache.catalina.core.AprLifecycleListener":
            instance   => $name,
            class_name => 'org.apache.catalina.core.AprLifecycleListener',
            attributes => [{
                    'SSLEngine' => 'on',
                }
                ],
        }
    }

    if ($jmx_enabled and $jmx_authenticate) {
        tomcat::jmx::init { $name: }
    }

    tomcat::listener { "${name}:org.apache.catalina.core.JasperListener":
        instance   => $name,
        class_name => 'org.apache.catalina.core.JasperListener',
    }

    tomcat::listener { "${name}:org.apache.catalina.core.JreMemoryLeakPreventionListener":
        instance   => $name,
        class_name => 'org.apache.catalina.core.JreMemoryLeakPreventionListener',
    }

    if ($tomcat::version < 7) {
        tomcat::listener { "${name}:org.apache.catalina.mbeans.ServerLifecycleListener":
            instance   => $name,
            class_name => 'org.apache.catalina.mbeans.ServerLifecycleListener',
        }
    }

    tomcat::listener { "${name}:org.apache.catalina.mbeans.GlobalResourcesLifecycleListener":
        instance   => $name,
        class_name => 'org.apache.catalina.mbeans.GlobalResourcesLifecycleListener',
    }

    file { [$instance_home, "${instance_home}/tomcat", "${instance_home}/tomcat/bin", "${instance_home}/tomcat/conf",
        "${instance_home}/tomcat/conf/Catalina", "${instance_home}/tomcat/conf/Catalina/localhost", "${instance_home}/tomcat/lib",
        "${instance_home}/tomcat/logs", "${instance_home}/tomcat/temp", "${instance_home}/tomcat/webapps", "${instance_home}/tomcat/work"
        ]:
        ensure  => directory,
        owner   => $name,
        group   => $name,
        mode    => '0640',
        require => User[$name],
    }

    file { "${instance_home}/tomcat/bin/bootstrap.jar":
        ensure => link,
        target => "/usr/share/tomcat${tomcat::version}/bin/bootstrap.jar",
        notify => Tomcat::Service[$name],
    }

    # For using apparmor profiles per instance it needs a file instead of a symlink
    exec { "copy ${instance_home}/tomcat/bin/catalina.sh":
        command => "/bin/cp /usr/share/tomcat${tomcat::version}/bin/catalina.sh ${instance_home}/tomcat/bin/catalina.sh",
        creates => "${instance_home}/tomcat/bin/catalina.sh",
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

    file { "${instance_home}/tomcat/conf/web.xml":
        ensure => link,
        target => "/etc/tomcat${tomcat::version}/web.xml",
        notify => Tomcat::Service[$name],
    }

    file { "${instance_home}/tomcat/bin/setenv.sh":
        content => template('tomcat/setenv.sh.erb'),
        notify  => Tomcat::Service[$name],
        owner   => $name,
        mode    => '0740',
    }

    user { $name:
        ensure   => present,
        home     => $instance_home,
        password => '!',
        comment  => "${name} instance user",
    }

    file { "/etc/tomcat.d/${name}":
        ensure  => $ensure,
        content => '',
        require => User[$name],
        notify  => Tomcat::Service[$name],
        mode    => '0640',
    }

    file { "${instance_home}/tomcat/conf/server.xml":
        ensure  => $ensure,
        owner   => $name,
        group   => $name,
        content => template('tomcat/server.xml.erb'),
        require => File["${instance_home}/tomcat"],
        notify  => Tomcat::Service[$name],
        mode    => '0640',
    }

    file { "${instance_home}/tomcat/conf/context.xml":
        ensure  => $ensure,
        owner   => $name,
        group   => $name,
        content => template('tomcat/context.xml.erb'),
        require => File["${instance_home}/tomcat"],
        notify  => Tomcat::Service[$name],
        mode    => '0640',
    }
}
