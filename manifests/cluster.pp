class tomcat::cluster ($instance) {
    concat { "${tomcat::params::home}/${instance}/tomcat/conf/engine-cluster.xml":
        owner => $instance,
        group => $instance,
    }

    concat { "${tomcat::params::home}/${instance}/tomcat/conf/host-cluster.xml":
        owner => $instance,
        group => $instance,
    }

    concat::fragment { "Adding Default Engine Cluster content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/engine-cluster.xml",
        order   => 00,
        content => "<?xml version='1.0' encoding='utf-8'?>",
    }

    concat::fragment { "Adding Default Host Cluster content for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/host-cluster.xml",
        order   => 00,
        content => "<?xml version='1.0' encoding='utf-8'?>",
    }
}
