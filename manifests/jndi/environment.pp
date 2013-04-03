define tomcat::jndi::environment (
    $instance,
    $env_name       = $name,
    $env_value,
    $env_type       = "java.lang.String",
    $env_override   = false,
) {
    $instance_home="/opt/tomcat/sites/${instance}"

    concat::fragment { "Adding JNDI Environment var ${env_name} for ${instance}" :
        target  => "${instance_home}/tomcat/conf/server-jndi-environmentvars.xml",
        order   => 01,
        content => template('tomcat/server-jndi-environmentvars.xml.erb'),
    }
}
