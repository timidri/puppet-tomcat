define tomcat::jndi::resource (
    $resource_name,
    $instance,
    $type          = 'context',
    $resource_type = 'javax.sql.DataSource',
    $attributes    = [],
) {
    concat::fragment { "Adding JNDI Resource ${resource_name} for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/${type}-jndi-resources.xml",
        order   => 01,
        content => template('tomcat/jndi-resources.xml.erb'),
    }
}
