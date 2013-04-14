define tomcat::jndi::database::mysql (
    $database,
    $username,
    $password,
    $resource_name      = 'jdbc/MysqlPool',
    $instance           = $name,
    $host               = 'localhost',
    $driver             = 'com.mysql.jdbc.Driver',
    $use_unicode        = true,
    $character_encoding = 'UTF-8',
    $fast_date_parsing  = false,
    $max_active         = '8',
    $max_idle           = '4',
) {
    tomcat::jndi::resource { $name:
        instance   => $instance,
        attributes => [
            {'auth'              => 'Container' },
            {'username'          => $username },
            {'password'          => $password },
            {'driverClassName'   => $driver },
            {'url'               => "jdbc:mysql://${host}/${database}?useUnicode=${use_unicode}&amp;characterEncoding=${character_encoding}&amp;useFastDateParsing=${fast_date_parsing}" },
            {'max_active'        => $max_active },
            {'max_idle'          => $max_idle },
        ],
    }
    
    tomcat::lib::maven { "${instance}:mysql-connector-java-5.1.24":
        lib        => "mysql-connector-java-5.1.24.jar",
        instance   => $instance,
        groupid    => 'mysql',
        artifactid => 'mysql-connector-java',
        version    => '5.1.24',
    }
}