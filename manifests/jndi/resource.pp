define tomcat::jndi::resource (
    $resource_name,
    $instance      = $name,
    $context       = undef,
    $resource_type = 'javax.sql.DataSource',
    $attributes    = [],
) {
    concat::fragment { "Adding JNDI Resource ${resource_name} for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/context-jndi-resources.xml",
        order   => 01,
        content => template('tomcat/context-jndi-resources.xml.erb'),
    }
}