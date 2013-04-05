define tomcat::jndi::resource ($instance, $resource_name = $name, $resource_type = 'javax.sql.DataSource', $attributes = []) {
    concat::fragment { "Adding JNDI Resource ${resource_name} for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/server-jndi-resources.xml",
        order   => 01,
        content => template('tomcat/server-jndi-resources.xml.erb'),
    }
}