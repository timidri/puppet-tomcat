class tomcat::valve ($instance) {
    concat { "${tomcat::params::home}/${instance}/tomcat/conf/engine-valves.xml":
        owner => $instance,
        group => $instance,
    }

    concat { "${tomcat::params::home}/${instance}/tomcat/conf/host-valves.xml":
        owner => $instance,
        group => $instance,
    }

    concat::fragment { "Adding Default Engine Valves content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/engine-valves.xml",
        order   => 00,
        content => "<?xml version='1.0' encoding='utf-8'?>",
    }

    concat::fragment { "Adding Default Host Valves content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/host-valves.xml",
        order   => 00,
        content => "<?xml version='1.0' encoding='utf-8'?>",
    }
}
