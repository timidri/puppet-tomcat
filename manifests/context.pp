define tomcat::context ($instance, $app, $content) {
    file { "${tomcat::params::home}/${instance}/tomcat/conf/Catalina/localhost/${app}.xml":
        content => $content,
        owner   => $instance,
        mode    => '0644',
    }
}
