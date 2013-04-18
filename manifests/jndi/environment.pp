define tomcat::jndi::environment (
    $instance,
    $type         = 'context',
    $env_name     = $name,
    $env_value,
    $env_type     = 'java.lang.String',
    $env_override = false,) {
    concat::fragment { "Adding JNDI Environment var ${env_name} for ${instance}":
        target  => "${tomcat::params::home}/${instance}/tomcat/conf/${type}-jndi-environmentvars.xml",
        order   => 01,
        content => template('tomcat/jndi-environmentvars.xml.erb'),
    }
}
