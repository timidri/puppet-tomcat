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
    $instance             = $name,
    $address              = '',
    $port                 = 8009,
    $protocol             = 'AJP/1.3',
    $uri_encoding         = 'UTF-8',
) {
    tomcat::connector { $name:
        instance     => $instance,
        port         => $port,
        uri_encoding => $uri_encoding,
        attributes   => [{
                'address' => $address
            }
            ,{
                'protocol' => $protocol
            }
            ,]
    }
}
