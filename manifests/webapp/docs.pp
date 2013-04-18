# This resource enables the tomcat docs for an instance.
#
# === Parameters
#
# Document parameters here.
#
# [*instance*]  The instance this application should be installed in (see tomcat::instance). Defaults to $name.
#
# === Variables
#
# === Examples
#
#  tomcat::webapp::docs { 'instance_1': }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::webapp::docs ($instance = $name) {
    include tomcat

    if (!defined(Package["tomcat${tomcat::version}-docs"])) {
        package { "tomcat${tomcat::version}-docs": ensure => held, }
    }

    tomcat::context { "${instance}:docs.xml":
        content  => "<Context path=\"/manager\" privileged=\"true\" antiResourceLocking=\"false\" docBase=\"/usr/share/tomcat${tomcat::version}-docs/docs\"></Context>",
        context  => 'docs',
        instance => $instance,
        require  => Tomcat::Instance[$instance],
    }
}
