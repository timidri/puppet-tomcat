# This resource enables the tomcat manager and host-manager for an instance.
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
#  tomcat::manager { 'instance_1': }
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::manager ($instance = $name) {
    include tomcat
    
    if (!defined(Package["tomcat${tomcat::version}-admin"])) {
        package { "tomcat${tomcat::version}-admin": ensure => held, }
    }

    tomcat::context { "${name} manager.xml":
        content  => "<Context path=\"/manager\" privileged=\"true\" antiResourceLocking=\"false\" docBase=\"/usr/share/tomcat${tomcat::version}-admin/manager\"></Context>",
        context  => 'manager',
        instance => $instance,
        require  => Tomcat::Instance[$instance],
    }

    tomcat::context { "${name} host-manager.xml":
        content  => "<Context path=\"/host-manager\" privileged=\"true\" antiResourceLocking=\"false\" docBase=\"/usr/share/tomcat${tomcat::version}-admin/host-manager\"></Context>",
        context  => 'host-manager',
        instance => $instance,
        require  => Tomcat::Instance[$instance],
    }
}
