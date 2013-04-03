define tomcat::instance (
    $http_port     = '8080',
    $https_port    = '8443',
    $ajp_port      = '8009',
    $shutdown_port = '8005',
    $scheme        = 'http',
    $apr_enabled   = true,
    $max_heap      = '1024m',
    $min_heap      = '1024m',
    $min_perm      = '384m',
    $max_perm      = '384m',) {
    $instance_home = "${tomcat::params::home}/${name}"

    tomcat::service { $name: }

    file { [
        $instance_home,
        "${instance_home}/tomcat",
        "${instance_home}/tomcat/bin",
        "${instance_home}/tomcat/conf",
        "${instance_home}/tomcat/conf/Catalina",
        "${instance_home}/tomcat/conf/Catalina/localhost",
        "${instance_home}/tomcat/lib",
        "${instance_home}/tomcat/logs",
        "${instance_home}/tomcat/temp",
        "${instance_home}/tomcat/webapps",
        "${instance_home}/tomcat/work"]:
        ensure  => directory,
        owner   => $name,
        group   => $name,
        require => User[$name],
    }

    file { "${instance_home}/tomcat/bin/bootstrap.jar": target => "/usr/share/tomcat${tomcat::version}/bin/bootstrap.jar", }

    file { "${instance_home}/tomcat/bin/catalina.sh": target => "/usr/share/tomcat${tomcat::version}/bin/catalina.sh", }

    file { "${instance_home}/tomcat/bin/digest.sh": target => "/usr/share/tomcat${tomcat::version}/bin/digest.sh", }

    file { "${instance_home}/tomcat/bin/setclasspath.sh": target => "/usr/share/tomcat${tomcat::version}/bin/setclasspath.sh", }

    file { "${instance_home}/tomcat/bin/shutdown.sh": target => "/usr/share/tomcat${tomcat::version}/bin/shutdown.sh", }

    file { "${instance_home}/tomcat/bin/startup.sh": target => "/usr/share/tomcat${tomcat::version}/bin/startup.sh", }

    file { "${instance_home}/tomcat/bin/tool-wrapper.sh": target => "/usr/share/tomcat${tomcat::version}/bin/tool-wrapper.sh", }

    file { "${instance_home}/tomcat/bin/version.sh": target => "/usr/share/tomcat${tomcat::version}/bin/version.sh", }

    file { "${instance_home}/tomcat/conf/catalina.properties": target => "/etc/tomcat${tomcat::version}/catalina.properties", }

    file { "${instance_home}/tomcat/conf/context.xml": target => "/etc/tomcat${tomcat::version}/context.xml", }

    file { "${instance_home}/tomcat/conf/logging.properties": target => "/etc/tomcat${tomcat::version}/logging.properties", }

    file { "${instance_home}/tomcat/conf/policy.d": target => "/etc/tomcat${tomcat::version}/policy.d", }

    file { "${instance_home}/tomcat/conf/tomcat-users.xml": target => "/etc/tomcat${tomcat::version}/tomcat-users.xml", }

    file { "${instance_home}/tomcat/conf/web.xml": target => "/etc/tomcat${tomcat::version}/web.xml", }

    user { $name:
        home     => $instance_home,
        password => '!',
        ensure   => present,
        comment  => "${name} instance user",
        require  => File[$tomcat::params::home],
    }

    class { 'tomcat::jndi':
        instance => $name,
        require  => File["${instance_home}/tomcat/conf"],
    }

    class { 'tomcat::realm':
        instance => $name,
        require  => File["${instance_home}/tomcat/conf"],
    }

    class { 'tomcat::valve':
        instance => $name,
        require  => File["${instance_home}/tomcat/conf"],
    }

    class { 'tomcat::cluster':
        instance => $name,
        require  => File["${instance_home}/tomcat/conf"],
    }

    file { "/etc/tomcat.d/${name}":
        ensure  => present,
        content => "",
        require => User[$name],
    }

    file { "${instance_home}/tomcat/conf/server.xml":
        owner   => $name,
        group   => $name,
        content => template("tomcat/server.xml.erb"),
        require => File["${instance_home}/tomcat"],
    }

    profile_d::script { 'catalina_opts.sh':
        ensure  => present,
        content => "export CATALINA_OPTS=\"-Xmx${max_heap} -Xms${min_heap} -XX:PermSize=${min_perm} -XX:MaxPermSize=${max_perm}\"",
        user    => $name,
    }
}
