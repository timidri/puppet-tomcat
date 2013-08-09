class tomcat::install::package {
        package { "${tomcat::package_name}":
            ensure => installed,
        }   
}