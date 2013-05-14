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
# [*factory*] Connection factory to use (defaults to 'org.apache.tomcat.jdbc.pool.DataSourceFactory'),
# [*jmx_enabled*] Enable jmx for the connection pool (defaults to true),
# [*validation_query*] The query to use to check if a connection is still valid (defaults to 'SELECT 1'),
#
# === Variables
#
# === Examples
#
#  tomcat::jndi::database::mysql { 'tomcat_01':
#   database        => 'my_mysql_db',
#   username        => 'my_user',
#   password        => 'my_passw0rd',
#   resource_name   => 'jdbc/myMysqlDb',
#   host            => 'localhost',
#   use_unicode     => false,
#   character_encoding => 'latin-1',
#   fast_date_parsing  => true,
#   initial_size    => 5,
#   max_active      => 99,
#   max_idle        => 1,
#   jmx_enabled     => false,
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
    $instance,
    $resource_name      = 'jdbc/MysqlPool',
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
    $auto_reconnect     = true,
    $validation_query   = 'SELECT 1',
) {
    tomcat::jndi::resource { "${instance}:${resource_name}":
        instance      => $instance,
        resource_name => $resource_name,
        attributes    => [
            {'auth' => 'Container'},
            {'username' => $username},
            {'password' => $password},
            {'driverClassName' => $driver},
            {'url' => "jdbc:mysql://${host}/${database}?useUnicode=${use_unicode}&amp;characterEncoding=${character_encoding}&amp;useFastDateParsing=${fast_date_parsing}&amp;autoReconnect=${auto_reconnect}"},
            {'initialSize'=> $initial_size },
            {'maxActive' => $max_active },
            {'maxIdle' => $max_idle },
            {'factory' => $factory },
            {'jmxEnabled' => $jmx_enabled },
            {'validationQuery' => $validation_query },
        ],
    }

    if(!defined(Tomcat::Lib::Maven["${instance}:mysql-connector-java-5.1.24"])) {
	    tomcat::lib::maven { "${instance}:mysql-connector-java-5.1.24":
	        lib        => 'mysql-connector-java-5.1.24.jar',
	        instance   => $instance,
	        groupid    => 'mysql',
	        artifactid => 'mysql-connector-java',
	        version    => '5.1.24',
	    }
    }

    if ('org.apache.tomcat.jdbc' in $factory and !defined(Tomcat::Lib::Maven["${instance}:tomcat-jdbc-7.0.19"])) {
        tomcat::lib::maven { "${instance}:tomcat-jdbc-7.0.19":
            lib        => 'tomcat-jdbc-7.0.19.jar',
            instance   => $instance,
            groupid    => 'org.apache.tomcat',
            artifactid => 'tomcat-jdbc',
            version    => '7.0.19',
        }
    }
}
