define tomcat::realm::ldap (
    $instance,
    $classname      = 'org.apache.catalina.realm.JNDIRealm',
    $connectionurl  = 'ldaps://localhost:1636',
    $userpattern    = 'cn={0},ou=people,dc=proteon,dc=nl',
    $rolebase       = 'ou=tomcat,ou=applications,dc=proteon,dc=nl',
    $rolename       = 'cn',
    $rolesearch     = '(member={0})',
    $type           = 'engine', #engine / host
) {
    $instance_home="/opt/tomcat/sites/${instance}"

    concat::fragment { "Adding LDAP Realm content for ${instance}":
        target  => "${instance_home}/tomcat/conf/${type}-realms.xml",
        order   => 01,
        content => "<Realm className=\"${classname}\" \
connectionURL=\"${connectionurl}\" \
userPattern=\"${userpattern}\" \
roleBase=\"${rolebase}\" \
roleName=\"${rolename}\" \
roleSearch=\"${rolesearch}\" />",
    }
}
