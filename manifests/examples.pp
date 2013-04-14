# This resource enables the tomcat examples for an instance.
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
#  tomcat::examples { 'instance_1': }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::examples ($instance = $name) {
    include tomcat
    
    if (!defined(Package["tomcat${tomcat::version}-examples"])) {
        package { "tomcat${tomcat::version}-examples": ensure => held, }
    }

    tomcat::context { "${instance}:examples.xml":
        content  => "<Context path=\"/manager\" privileged=\"true\" antiResourceLocking=\"false\" docBase=\"/usr/share/tomcat${tomcat::version}-examples/examples\"></Context>",
        context  => 'examples',
        instance => $instance,
        require  => Tomcat::Instance[$instance],
    }
}
