define tomcat::jndi::database::hsql (
    $instance,
    $resource_name = $name,
    $resource_type = 'javax.sql.DataSource',
    $auth          = 'Container',
    $username      = 'sa',
    $password      = '',
    $driver        = 'org.hsqldb.jdbcDriver',
    $url           = "jdbc:hsqldb:data/hsql/data",
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

    tomcat::lib::maven { 'hsqldb-2.2.9':
        instance   => $instance,
        groupid    => 'org.hsqldb',
        artifactid => 'hsqldb',
        version    => '2.2.9',
    }
}