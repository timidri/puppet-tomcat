# This resource installs a tomcat context definition.
#
# === Parameters
#
# Document parameters here.
#
# [*instance*]   The instance this definition should be installed in (see tomcat::instance).
# [*context*]    The context this configuration applies.
# [*content*]    The content of the context definition.
#
# === Variables
#
# === Examples
#
#  tomcat::context { 'ROOT':
#   instance => 'instance_1',
#   content  => '<Context antiResourceLocking="false"/>',
#  }
# === Authors
#
# Sander Bilo <sander@proteon.nl>
#
# === Copyright
#
# Copyright 2013 Proteon.
#
define tomcat::context ($instance, $context = $name, $content) {
    file { "${tomcat::params::home}/${instance}/tomcat/conf/Catalina/localhost/${context}.xml":
        content => $content,
        owner   => $instance,
        mode    => '0644',
    }
}
