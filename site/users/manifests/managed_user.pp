define users::managed_user (
  $group = $title,
) {

  user { $title:
    ensure => present,
    gid    => 'wheel',
  }
  
  file { "/home/${title}":
    ensure => directory,
    owner  => $title,
    group  => $group,
  }
  
  file { "/home/${title}/${title}.conf":
    ensure => file,
    owner  => $title,
    group  => $group,
    content => "This file belongs to ${title}",
  }
}

