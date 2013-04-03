define tomcat::lib ($instance, $source) {
    file { "${tomcat::params::home}/${instance}/tomcat/lib/${name}":
        source => $source,
        owner  => $instance,
        mode   => '0644',
        notify => Tomcat::Service[$instance],
    }
}