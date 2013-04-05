define tomcat::jndi::database (
    $instance,
    $resource_name = $name,
    $resource_type = 'javax.sql.DataSource',
    $auth          = 'Container',
    $username      = undef,
    $password      = undef,
    $driver        = 'org.hsql.jdbcDriver',
    $url           = 'jdbc:HypersonicSQL:database',
    $max_active    = '8',
    $max_idle      = '4',
) {
    tomcat::jndi::resource { $name:
        instance   => $instance,
        attributes => [
            {'auth'              => $auth },
            {'username'          => $username },
            {'password'          => $password },
            {'driverClassName'   => $driver },
            {'url'               => $url },
            {'max_active'        => $max_active },
            {'max_idle'          => $max_idle },
        ],
    }
}