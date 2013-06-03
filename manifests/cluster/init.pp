# This resource installs default cluster resources in an instance, don't use it directly.
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::cluster::init (
    $instance = $name,
    $ensure   = present,) {
    if ($ensure != absent) {
        include concat::setup

        concat { "${tomcat::params::home}/${instance}/tomcat/conf/engine-cluster.xml":
            owner   => $instance,
            group   => $instance,
            mode    => '0640',
            require => File["${tomcat::params::home}/${instance}/tomcat/conf"],
        }

        concat { "${tomcat::params::home}/${instance}/tomcat/conf/host-cluster.xml":
            owner   => $instance,
            group   => $instance,
            require => File["${tomcat::params::home}/${instance}/tomcat/conf"],
        }

        concat::fragment { "Adding Default Engine Cluster content for ${instance}":
            target  => "${tomcat::params::home}/${instance}/tomcat/conf/engine-cluster.xml",
            order   => 00,
            content => '<?xml version=\'1.0\' encoding=\'utf-8\'?>',
        }

        concat::fragment { "Adding Default Host Cluster content for ${instance}":
            target  => "${tomcat::params::home}/${instance}/tomcat/conf/host-cluster.xml",
            order   => 00,
            content => '<?xml version=\'1.0\' encoding=\'utf-8\'?>',
        }
    }
}
