class users {

  user {'fundamentals':
    ensure => present,
  }
  
  users::managed_user { 'mike': }
  
  users::managed_user { 'ram':
    group => 'root',
  }
  
}