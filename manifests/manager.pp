define tomcat::manager ($instance) {
    package { "tomcat${tomcat::version}-admin": ensure => held, }

    tomcat::context { "${name} manager.xml":
        content  => "<Context path=\"/manager\" privileged=\"true\" antiResourceLocking=\"false\" docBase=\"/usr/share/tomcat${tomcat::version}-admin/manager\"></Context>",
        app      => 'manager',
        instance => $instance,
    }

    tomcat::context { "${name} host-manager.xml":
        content  => "<Context path=\"/host-manager\" privileged=\"true\" antiResourceLocking=\"false\" docBase=\"/usr/share/tomcat${tomcat::version}-admin/host-manager\"></Context>",
        app      => 'host-manager',
        instance => $instance,
    }
}
