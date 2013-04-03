define tomcat::service () {
    service { $name:
        name       => 'tomcat',
        ensure     => running,
        pattern    => "-Dcatalina.base=${tomcat::params::home}/${name}/tomcat",
        start      => "/usr/sbin/tomcat start --instance=${name} --timeout=0",
        stop       => "/usr/sbin/tomcat stop --instance=${name} --timeout=0",
        hasrestart => false,
        hasstatus  => false,
    }
}
