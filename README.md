puppet-tomcat
=============

Puppet code for deploying and configuring Tomcat multi-instance on Debian-like servers.

Depencendies:

    'ripienaar/concat', '>=0.2.0'
    'klangrud/profile_d', '>=0.0.1'
    'proteon/maven', '>=1.0.1'
    
Optional:
    'puppetlabs/mysql',  '>=0.6.1' # When using jndi mysql database resources

Basic usage
-------------------------
To install Tomcat

    include tomcat

Configure an instance
-------------------------
To create an instance

    tomcat::instance { 'tomcat_1': }

A slightly more complicated example

    tomcat::instance { 'tomcat_2':
      shutdown_port => '18005',
      apr_enabled   => false,
      min_heap      => '1024m',
      max_heap      => '2048m',
      min_perm      => '384m',
      max_perm      => '512m',
      unpack_wars   => false,
      auto_deploy   => false,
    }
    
Install a web application
-------------------------
To install a web application (.war)

    tomcat::webapp { 'ROOT': 
      instance   => 'tomcat_02',
      source	 => 'puppet:///yourapplication/downloadable.war',
    }

Install a web application from a maven repository
-------------------------
To install a web application (.war) from a maven artifact repository
    
    tomcat::webapp::maven { 'testapplication': 
      instance   => 'tomcat_01',
      groupid    => 'com.yourcompany.project',
      artifactid => 'yourwebapp',
      version    => '1.0.0-SNAPSHOT',
      repos	 => ['http://maven.yourcompany.com/'],
    }

Configure a jndi record for an instance
-------------------------
To add a database resource

    tomcat::jndi::database { 'jdbc/database':
      instance    => 'tomcat_3',
      username    => 'root',
      password    => 'root',
      driver      => 'com.mysql.jdbc.Driver'
      url         => 'jdbc:mysql://localhost:3306/database',
    }
    
To add a mysql database resource 

    tomcat::jndi::database::mysql { 'jdbc/mysqldb':
      instance    		 => 'tomcat_1',
      database	  		 => 'database_01',
      username	  		 => 'dbuser',
      password	  		 => 'qwerty',
      host        		 => 'db_server_1',
      use_unicode 		 => false,
      character_encoding 	 => 'UTF-8',
    }
    
To add an environment variable 

    tomcat::jndi::environment { 'greeting':
      instance    => 'tomcat_3',
      env_value   => 'hello world',
    }

Configure a connector for an instance
-------------------------
This example will only enable the AJP connector for this instance,
because the connector resource has the same title as the instance. 
Keep in mind that this won't create the default http connector it would 
when not specifying any connector.

    tomcat::connector::ajp { 'tomcat_1':
      instance	=> 'tomcat_1',
      port 	=> 8009,
    }
    
    tomcat::instance { 'tomcat_1': }

Configure a realm (authentication) for an instance
-------------------------
To add a userdatabase with the 'MemoryUserDatabaseFactory' (tomcat-users.xml)

    tomcat::realm::userdatabase { 'tomcat_1_userdatabase_realm':
      instance => 'tomcat_1'
    }

Add roles to the userdatabase

    tomcat::realm::userdatabase::role { ['role_1','manager-gui','admin-gui']: }

Add a user to the userdatabase (this example allows this user to use the manager applications)

    tomcat::realm::userdatabase::user { 'user_1':
      instance => 'tomcat_1',
      password => '1_tacmot',
      roles    => 'manager-gui,admin-gui',
    }

Configure clustering for an instance
-------------------------
To add simple clustering for instances

    tomcat::cluster::simple { ['tomcat_1','tomcat_2','tomcat_3']: }

Configure the tomcat manager and host-manager
-------------------------
To add the manager applications for instances

    tomcat::webapp::manager { ['tomcat_1','tomcat_2']:}

This will make them available at /manager and /host-manager
    
Configure the tomcat docs
-------------------------
To add the docs for instances

    tomcat::webapp::docs { 'tomcat_1':}

This will make them available at /docs

Configure the tomcat example applications
-------------------------
To add the example applications for instances

    tomcat::webapp::examples { 'tomcat_1':}

This will make them available at /examples
