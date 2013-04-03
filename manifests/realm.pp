class tomcat::realm ($instance) {
    concat { "${tomcat::params::home}/${instance}/tomcat/conf/engine-realms.xml":
        owner => $instance,
        group => $instance,
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
