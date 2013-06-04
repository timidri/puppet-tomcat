define tomcat::jmx::user (
    $username = $name,
    $instance,
    $password,
    $permission) {
    concat::fragment { "${instance}:jmx:${username}:password":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/jmxremote.password",
        order   => 00,
        content => "${username} ${password}",
    }

    concat::fragment { "${instance}:jmx:${username}:access":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/jmxremote.access",
        order   => 00,
        content => "${username} ${permission}",
    }
}
