class nginx (
  $package  = $nginx::params::package,
  $owner    = $nginx::params::owner,
  $group    = $nginx::params::group,
  $docroot  = $nginx::params::docroot,
  $confdir  = $nginx::params::confdir,
  $blockdir = $nginx::params::blockdir,
  $logdir   = $nginx::params::logdir,
  $service  = $nginx::params::service,
  $user     = $nginx::params::user,
  $message  = 'Message from default params',
) inherits nginx::params {

  File {
    owner => $owner,
    group => $group,
    mode  => '0644',
  }
  
  notify { "MESSGE IS ------------- ${message}": }

  package { $package:
    ensure => present,
  }
  
  file { $docroot:
    ensure => directory,
    mode   => '0755',
  }
  
  file { "${docroot}/index.html":
    ensure  => file,
    #source  => 'puppet:///modules/nginx/index.html',
    content => epp('nginx/index.html.epp'),
    require => File[$docroot],
    #before  => Service[$service],
  }
  
  file { $confdir:
    ensure  => directory,
    mode    => '0755',
    require => Package[$package],
  }
  
  file { "${confdir}/nginx.conf":
    ensure  => file,
    #source  => 'puppet:///modules/nginx/nginx.conf',
    content => epp('nginx/nginx.conf.epp',
                    {
                      user     => $user,
                      logdir   => $logdir,
                      blockdir => $blockdir,
                      confdir  => $confdir,
                    }),
    require => File[$confdir],
    #notify  => Service[$service],
  }
  
  file { $blockdir:
    ensure => directory,
    mode   => '0755',
    require => File[$confdir],
  }
  
  file { "${confdir}/default.conf":
    ensure => file,
    #source => 'puppet:///modules/nginx/default.conf',
    content => epp('nginx/default.conf.epp', { docroot => $docroot, }),
    require => File[$blockdir],
    #notify  => Service[$service],
  }
  
  #service { $service:
  #  ensure => running,
  #}

}