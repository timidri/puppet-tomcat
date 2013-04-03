define tomcat::realm::userdatabase (
  $instance     = $name,
  $classname    = 'org.apache.catalina.realm.UserDatabaseRealm',
  $resourcename = 'UserDatabase',
  $type         = 'engine', # engine / host
  ) {
  concat::fragment { "Adding ${type} UserDatabase Realm content for $instance":
    target  => "${tomcat::params::home}/${instance}/tomcat/conf/${type}-realms.xml",
    order   => 01,
    content => "<Realm classname=\"${classname}\" resourceName=\"${resourcename}\">",
  }
}
