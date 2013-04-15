# ==== Resource: tomcat::jndi::database::mysql
#
# This resource adds a mysql database connection to the jndi resources. It will also create the database with the provided
# parameters if not present or defined elsewhere.
#
# === Parameters
#
# Document parameters here.
#
# [*database*] The name of the database to create the resource for.
# [*username*] The username of the database.
# [*password*] The password of the database.
# [*resource_name*] The name of the jndi resource (defaults to 'jdbc/MysqlPool').
# [*instance*] The name of the instance we're creating the resource on (defaults to $name).
# [*host*] The host where the database runs on (defaults to 'localhost').
# [*driver*] The driver class to use (defaults to 'com.mysql.jdbc.Driver').
# [*use_unicode*] Use unicode (defaults to true).
# [*character_encoding*] Character encoding to use (defaults to 'UTF-8').
# [*fast_date_parsing*] Use fast date parsing (defaults to false).
# [*initial_size*] Initial pool size (defaults to 4).
# [*max_active*] Max active connections (defaults to 8).
# [*max_idle*] Minimal active connections (defaults to 4).
#
# === Variables
#
# === Examples
#
#  class { java:
#    location        => 'http://apt.your-company-repository.com/ubuntu/',
#    package         => 'sun-java6-jdk',
#    repository_name => 'your-company-repository',
#    release         => $::lsbdistcodename,
#    repos           => 'main',
#    key             => '1234567',
#    key_server      => 'keyserver.ubuntu.com',
#  }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
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
    $initial_size       = '10',
    $max_active         = '100',
    $max_idle           = '10',
    $factory            = 'org.apache.tomcat.jdbc.pool.DataSourceFactory',
    $jmx_enabled        = true,
) {
    tomcat::jndi::resource { $name:
        instance      => $instance,
        resource_name => $resource_name,
        attributes    => [
            {'auth' => 'Container'},
            {'username' => $username},
            {'password' => $password},
            {'driverClassName' => $driver},
            {'url' => "jdbc:mysql://${host}/${database}?useUnicode=${use_unicode}&amp;characterEncoding=${character_encoding}&amp;useFastDateParsing=${fast_date_parsing}"},
            {'initialSize'=> $initial_size },
            {'maxActive' => $max_active },
            {'maxIdle' => $max_idle },
            {'factory' => $factory },
            {'jmxEnabled' => $jmx_enabled },
        ],
    }

    tomcat::lib::maven { "${instance}:mysql-connector-java-5.1.24":
        lib        => "mysql-connector-java-5.1.24.jar",
        instance   => $instance,
        groupid    => 'mysql',
        artifactid => 'mysql-connector-java',
        version    => '5.1.24',
    }
    
    tomcat::lib::maven { "${instance}:tomcat-jdbc-7.0.19":
        lib        => "tomcat-jdbc-7.0.19.jar",
        instance   => $instance,
        groupid    => 'org.apache.tomcat',
        artifactid => 'tomcat-jdbc',
        version    => '7.0.19',
    }

    if (!defined(Mysql::Db[$name]) and $host == 'localhost') {
        include mysql::server
        
        mysql::db { $database:
            user     => $username,
            password => $password,
        }
    }
}