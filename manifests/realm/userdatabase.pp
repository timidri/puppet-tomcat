define tomcat::realm::userdatabase (
    $instance      = $name,
    $class_name    = 'org.apache.catalina.realm.UserDatabaseRealm',
    $resource_name = 'UserDatabase',
    $type          = 'engine',) {
    include concat::setup

    concat::fragment { "Adding ${type} UserDatabase Realm content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/${type}-realms.xml",
        order   => 01,
        content => "<Realm className=\"${class_name}\" resourceName=\"${resource_name}\" />",
    }

    if (!defined(Tomcat::Jndi::Resource["${instance}:${resource_name}"])) {
        tomcat::jndi::resource { "${instance}:${resource_name}":
            resource_name => $resource_name,
            instance      => $instance,
            type          => 'server',
            resource_type => 'org.apache.catalina.UserDatabase',
            attributes    => [{
                    'factory' => 'org.apache.catalina.users.MemoryUserDatabaseFactory'
                }
                , {
                    'conf' => 'conf/tomcat-users.xml'
                }
                ],
        }

        concat { "${tomcat::params::home}/${instance}/tomcat/conf/tomcat-users.xml":
            owner   => $instance,
            group   => $instance,
            require => File["${tomcat::params::home}/${instance}/tomcat/conf"],
        }

        concat::fragment { "${tomcat::params::home}/${instance}/tomcat/conf/tomcat-users.xml:header":
            target  => "${tomcat::params::home}/${instance}/tomcat/conf/tomcat-users.xml",
            order   => 00,
            content => '<?xml version=\'1.0\' encoding=\'utf-8\'?>
<tomcat-users>
',
        }

        concat::fragment { "${tomcat::params::home}/${instance}/tomcat/conf/tomcat-users.xml:footer":
            target  => "${tomcat::params::home}/${instance}/tomcat/conf/tomcat-users.xml",
            order   => 03,
            content => '
</tomcat-users>',
        }
    }
}

define tomcat::realm::userdatabase::user (
    $instance,
    $password,
    $username = $name,
    $roles    = '',) {
    concat::fragment { "${tomcat::params::home}/${instance}/tomcat/conf/tomcat-users.xml:user:${username}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/tomcat-users.xml",
        order   => 02,
        content => "<user username=\"${username}\" password=\"${password}\" roles=\"${roles}\"/>",
    }
}

define tomcat::realm::userdatabase::role (
    $instance,
    $role = $name,) {
    concat::fragment { "${tomcat::params::home}/${instance}/tomcat/conf/tomcat-users.xml:role:${role}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/tomcat-users.xml",
        order   => 01,
        content => "<role rolename=\"${role}\"/>",
    }
}
