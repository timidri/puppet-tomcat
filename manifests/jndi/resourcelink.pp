define tomcat::jndi::resourcelink ($instance, $resourcelink_name = $name, $resourelink_factory = '', $attributes = []) {
    concat::fragment { "Adding JNDI ResourceLink ${resourcelink_name} for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/context-jndi-resourcelinks.xml",
        order   => 01,
        content => template('tomcat/context-jndi-resourcelinks.xml.erb'),
    }
}