# ==== Resource: tomcat::connector::ajp
#
# This resource creates a tomcat AJP connector, see : http://tomcat.apache.org/tomcat-7.0-doc/config/ajp.html
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
define tomcat::connector::ajp (
    $ensure       = present,
    $instance     = $name,
    $address      = '0.0.0.0',
    $port         = 8009,
    $protocol     = 'AJP/1.3',
    $uri_encoding = 'UTF-8',) {
    tomcat::connector { $name:
        ensure       => $ensure,
        instance     => $instance,
        port         => $port,
        uri_encoding => $uri_encoding,
        attributes   => [{
                'address' => $address
            }
            , {
                'protocol' => $protocol
            }
            ,]
    }
}
