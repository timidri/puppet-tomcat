# This resource installs a tomcat listener.
#
# === Parameters
#
# Document parameters here.
#
# [*instance*]
# [*class_name*]
#
# === Variables
#
# === Examples
#
#  tomcat::listener { 'instance_1:org.apache.catalina.core.AprLifecycleListener':
#    ensure       => present,
#    instance     => 'instance_1',
#    class_name   => 'org.apache.catalina.core.AprLifecycleListener',
#    attributes   => [{'SSLEngine' => 'on'}]
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
define tomcat::listener (
    $instance,
    $class_name,
    $attributes = [],
    $ensure     = present) {
    if ($ensure != absent) {
        concat::fragment { "Adding ${class_name} Connector for ${instance}":
            target  => "${tomcat::params::home}/${instance}/tomcat/conf/server-listeners.xml",
            order   => 01,
            content => template('tomcat/listener.xml.erb'),
        }
    }

}
