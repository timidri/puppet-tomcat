# This resource installs a library (jar) from a maven repository in an instance.
#
# === Parameters
#
# Document parameters here.
#
# [*lib*]           The outputfile (artifactid). Defaults to $name.jar
# [*instance*]      The instance this library should be installed in (see tomcat::instance).
# [*groupid*]       The groupid of the library to install.
# [*artifactid*]    The artifactid of the library to install.
# [*version*]       The version of the library to install.
#
# === Variables
#
# === Examples
#
#  tomcat::lib::maven { 'mysql-connector-java-5.1.24':
#   instance   => 'instance_1',
#   groupid    => 'mysql',
#   artifactid => 'mysql-connector-java',
#   version    => '5.1.24',
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
define tomcat::lib::maven ($lib = $name, $instance, $groupid, $artifactid, $version, $repos =[]) {
    include ::maven
    
    maven { "${tomcat::params::home}/${instance}/tomcat/lib/${lib}.jar":
        groupid    => $groupid,
        artifactid => $artifactid,
        version    => $version,
        packaging  => 'jar',
        repos      => $repos,
        notify     => Tomcat::Instance[$instance],
        require    => Package['maven'],
    }
}