# ==== Resource: tomcat::connector::https
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
define tomcat::connector::https (
    $instance             = $name,
    $address              = '',
    $port                 = 8443,
    $scheme               = 'https',
    $secure               = true,
    $ssl_enabled          = true,
    $ssl_certificate_file = '',
    $uri_encoding         = 'UTF-8',
) {
    tomcat::connector { $name:
        instance     => $instance,
        port         => $port,
        uri_encoding => $uri_encoding,
        attributes   => [{
                'address' => $address
            }
            , {
                'scheme' => $scheme
            }
            , {
                'secure' => $secure
            }
            , {
                'SSLEnabled' => $ssl_enabled
            }
            , {
                'SSLCertificateFile' => $ssl_certificate_file
            }
            ,]
    }
}
