# This class installs default service resources in an instance, don't use it directly.
#
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::service ($ensure = 'running',) {
    service { $name:
        ensure     => 'running',
        provider   => 'base',
        pattern    => "-Dcatalina.base=${tomcat::params::home}/${name}/tomcat",
        start      => "/usr/sbin/tomcat start --instance=${name} --timeout=0",
        stop       => "/usr/sbin/tomcat stop --instance=${name} --timeout=0",
        hasrestart => false,
        hasstatus  => false,
    }
}
