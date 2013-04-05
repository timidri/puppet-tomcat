puppet-tomcat
=============

Puppet code for deploying and configuring Tomcat multi-instance on Debian-like servers.

Depencendies:

    'ripienaar/concat', '>=0.2.0'dependency
    'proteon/java', '>=0.1.0' (optional)
    'proteon/profile_d', '>=0.1.0'

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
      ip_address    = undef,
      http_port     = '18080',
      https_port    = '18443',
      ajp_port      = '18009',
      shutdown_port = '18005',
      scheme        = 'http',
      apr_enabled   = false,
      max_heap      = '1024m',
      min_heap      = '2048m',
      min_perm      = '384m',
      max_perm      = '512m',
      unpack_wars   = false,
      auto_deploy   = false,
    }

Configure a jndi for an instance
-------------------------
To add a database resource

    tomcat::jndi::database { 'jdbc/database':
      instance    => 'tomcat_3',
      username    => 'root',
      password    => 'root',
      driver      => 'com.mysql.jdbc.Driver'
      url         => 'jdbc:mysql://localhost:3306/database',
    }
    
To add an environment variable 

    tomcat::jndi::environment { 'greeting':
      instance    => 'tomcat_3',
      env_value   => 'hello world',
    }
    
Configure clustering for an instance
-------------------------
To add simple clustering for instances

    tomcat::cluster::simple { ['tomcat_1','tomcat_2','tomcat_3']: }

Configure the tomcat manager and host-manager
-------------------------
To add the manager applications for instances

    tomcat::manager { ['tomcat_1','tomcat_2']:}
