define tomcat::webapp ($app_name, $instance, $source) {
    file { "${tomcat::params::home}/${instance}/tomcat/webapps/${app_name}.war":
        source => $source,
        owner  => $instance,
        mode   => '0644',
        notify => Tomcat::Service[$instance],
    }
}
