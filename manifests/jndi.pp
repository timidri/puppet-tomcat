class tomcat::jndi ($instance) {
    concat { "${tomcat::params::home}/${instance}/tomcat/conf/server-jndi-resources.xml":
        owner => $instance,
        group => $instance,
    }

    concat { "${tomcat::params::home}/$instance/tomcat/conf/server-jndi-resourcelinks.xml":
        owner => $instance,
        group => $instance,
    }

    concat { "${tomcat::params::home}/$instance/tomcat/conf/server-jndi-environmentvars.xml":
        owner => $instance,
        group => $instance,
    }

    concat::fragment { "Adding Default JNDI Server Resources content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/server-jndi-resources.xml",
        order   => 00,
        content => "<?xml version='1.0' encoding='utf-8'?>",
    }

    concat::fragment { "Adding Default JNDI Server ResourceLinks content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/server-jndi-resourcelinks.xml",
        order   => 00,
        content => "<?xml version='1.0' encoding='utf-8'?>",
    }

    concat::fragment { "Adding Default JNDI Server Environment content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/server-jndi-environmentvars.xml",
        order   => 00,
        content => "<?xml version='1.0' encoding='utf-8'?>",
    }
}
