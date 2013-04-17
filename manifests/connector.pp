# ==== Resource: tomcat::connector
#
# This resource creates a tomcat connector, see : http://tomcat.apache.org/tomcat-7.0-doc/config/http.html
#
# === Parameters
#
# [*instance*]
# [*port*]
# [*uri_encoding*]
# [*attributes*]
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::connector (
    $instance                   = $name,
    $port                       = 0,
    $uri_encoding               = 'UTF-8',
    $attributes                 = [],
) {
    concat::fragment { "Adding ${name} Connector for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/connectors.xml",
        order   => 01,
        content => template('tomcat/connector.xml.erb'),
    }
}
