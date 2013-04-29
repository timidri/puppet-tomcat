# This resource installs a web application in an instance.
#
# === Parameters
#
# Document parameters here.
#
# [*webapp*]    The name of the application (context). Defaults to $name
# [*instance*]  The instance this application should be installed in (see tomcat::instance).
# [*source*]    The application to install (a war file).
#
# === Variables
#
# === Examples
#
#  tomcat::webapp { 'jira':
#   instance => 'instance_1',
#   source   => 'puppet:///modules/jira/jira.war',
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::webapp ($webapp = $name, $instance, $source) {
    file { "${tomcat::params::home}/${instance}/tomcat/webapps/${webapp}.war":
        source  => $source,
        owner   => $instance,
        mode    => '0644',
    }
}
