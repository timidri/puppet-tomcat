define tomcat::jndi::database (
    $instance      = $name,
    $resource_name = 'jdbc/DefaultPool',
    $resource_type = 'javax.sql.DataSource',
    $auth          = 'Container',
    $username      = undef,
    $password      = undef,
    $driver        = undef,
    $url           = undef,
    $max_active    = undef,
    $max_idle      = undef,
    $factory       = undef,
) {
    tomcat::jndi::resource { $name:
        instance        => $instance,
        resource_name   => $resource_name,
        attributes => [
            {'auth'              => $auth },
            {'username'          => $username },
            {'password'          => $password },
            {'driverClassName'   => $driver },
            {'url'               => $url },
            {'max_active'        => $max_active },
            {'max_idle'          => $max_idle },
            {'factory'           => $factory },
        ],
    }
}