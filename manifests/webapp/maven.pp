# This resource installs a web application from a maven repository in an instance.
#
# === Parameters
#
# Document parameters here.
#
# [*webapp*]        The name of the application (context). Defaults to $name
# [*instance*]      The instance this application should be installed in (see tomcat::instance).
# [*groupid*]       The groupid of the application to install.
# [*artifactid*]    The artifact of the application to install.
# [*version*]       The version of the application to install.
#
# === Variables
#
# === Examples
#
#  tomcat::webapp { 'jira':
#   instance => 'instance_1',
#   source   => 'puppet://jira/jira.war',
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::webapp::maven ($webapp = $name, $instance, $groupid, $artifactid, $version) {
    maven { "${tomcat::params::home}/${instance}/tomcat/webapps/${webapp}.war":
        groupid    => $groupid,
        artifactid => $artifactid,
        version    => $version,
        packaging  => 'war',
        require    => Tomcat::Instance[$instance],
    }
}