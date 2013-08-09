class tomcat::install::download {
  $tarname = "apache-tomcat-${tomcat::version}"
  $tarball = "${tarname}.tar.gz"
  $download_url = "http://apache.xl-mirror.nl/tomcat/tomcat-7/v${tomcat::version}/bin/${tarball}"

  file { $tomcat::installroot: ensure => directory, }

  wget::fetch { 'tomcat::download':
    source      => $download_url,
    destination => "${tomcat::installroot}/${tarball}",
    notify      => Exec['tomcat::untar'],
    require     => File[$tomcat::installroot],
  }

  exec { 'tomcat::untar':
    command => "tar xf ${tarball} && mv ${tarname} ${tomcat::version}",
    cwd     => $tomcat::installroot,
    creates => $tomcat::installpath,
  }
}
