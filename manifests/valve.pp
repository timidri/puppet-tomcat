# This resource installs default valve resources in an instance, don't use it directly.
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::valve ($instance = $name) {
    include concat::setup
    
    concat { "${tomcat::params::home}/${instance}/tomcat/conf/engine-valves.xml":
        owner => $instance,
        group => $instance,
        require  => File["${tomcat::params::home}/${instance}/tomcat/conf"],
    }

    concat { "${tomcat::params::home}/${instance}/tomcat/conf/host-valves.xml":
        owner => $instance,
        group => $instance,
        require  => File["${tomcat::params::home}/${instance}/tomcat/conf"],
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
