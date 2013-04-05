define tomcat::cluster::simple (
  $instance                  = $name,
  $channel_send_options      = '8',
  $multicast_ip              = '228.0.0.4',
  $multicast_port            = '45564',
  $multicast_frequency       = '500',
  $multicast_droptime        = '3000',
  $receiver_ip               = 'auto',
  $receiver_port             = '4000',
  $receiver_autobind         = '100',
  $receiver_selector_timeout = '5000',
  $receiver_max_threads      = '6',
  $type                      = 'engine', # engine / host
  ) {
  concat::fragment { "Adding Simple Cluster Config for ${instance}":
    target  => "${tomcat::params::home}/${instance}/tomcat/conf/${type}-cluster.xml",
    order   => 01,
    content => template('tomcat/cluster.xml.erb'),
  }
}
