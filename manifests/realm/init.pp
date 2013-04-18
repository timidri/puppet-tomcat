# This resource installs default realm resources in an instance, don't use it directly.
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::realm::init (
    $instance = $name,
    $ensure   = present,) {
    if ($ensure != absent) {
        include concat::setup

        concat { "${tomcat::params::home}/${instance}/tomcat/conf/engine-realms.xml":
            owner   => $instance,
            group   => $instance,
            require => File["${tomcat::params::home}/${instance}/tomcat/conf"],
        }

        concat::fragment { "Adding Default Engine Realms topcontent for ${instance}":
            target  => "${tomcat::params::home}/${instance}/tomcat/conf/engine-realms.xml",
            order   => 00,
            content => '<?xml version=\'1.0\' encoding=\'utf-8\'?>
<Realm className="org.apache.catalina.realm.LockOutRealm">
',
        }

        concat::fragment { "Adding Default Engine Realms bottomcontent for ${instance}":
            target  => "${tomcat::params::home}/${instance}/tomcat/conf/engine-realms.xml",
            order   => 02,
            content => '
</Realm>',
        }
    }
}
