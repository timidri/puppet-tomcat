# This resource installs default jndi resources in an instance, don't use it directly.
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::jndi ($instance = $name) {
    include concat::setup
    
    concat { "${tomcat::params::home}/${instance}/tomcat/conf/context-jndi-resources.xml":
        owner => $instance,
        group => $instance,
        require  => File["${tomcat::params::home}/${instance}/tomcat/conf"],
    }

    concat { "${tomcat::params::home}/${instance}/tomcat/conf/context-jndi-resourcelinks.xml":
        owner => $instance,
        group => $instance,
        require  => File["${tomcat::params::home}/${instance}/tomcat/conf"],
    }

    concat { "${tomcat::params::home}/${instance}/tomcat/conf/context-jndi-environmentvars.xml":
        owner => $instance,
        group => $instance,
        require  => File["${tomcat::params::home}/${instance}/tomcat/conf"],
    }

    concat::fragment { "Adding Default JNDI Server Resources content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/context-jndi-resources.xml",
        order   => 00,
        content => '<?xml version=\'1.0\' encoding=\'utf-8\'?>',
    }

    concat::fragment { "Adding Default JNDI Server ResourceLinks content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/context-jndi-resourcelinks.xml",
        order   => 00,
        content => '<?xml version=\'1.0\' encoding=\'utf-8\'?>',
    }

    concat::fragment { "Adding Default JNDI Server Environment content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/context-jndi-environmentvars.xml",
        order   => 00,
        content => '<?xml version=\'1.0\' encoding=\'utf-8\'?>',
    }
}
