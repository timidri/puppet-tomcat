# ==== Resource: tomcat::connector::http
#
# This resource creates a tomcat connector, see : http://tomcat.apache.org/tomcat-7.0-doc/config/http.html
#
# === Parameters
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::connector::http (
    $ensure       = present,
    $instance     = $name,
    $address      = '0.0.0.0',
    $port         = 8080,
    $scheme       = 'http',
    $uri_encoding = 'UTF-8',) {
    tomcat::connector { $instance:
        ensure       => $ensure,
        instance     => $instance,
        port         => $port,
        uri_encoding => $uri_encoding,
        attributes   => [{
                'address' => $address
            }
            , {
                'scheme' => $scheme
            }
            ]
    }
}
