# Install PHP

class php5 {

  package { [
      'php5',
      'php5-mysql',
      'php5-curl',
      'php5-gd',
      'php5-fpm',
    ]:
    ensure => present,
  }
  
  service { 'php5-fpm':
    ensure  => running,
    require => Package['php5-fpm'],
  }

}

class php5::wordpress {

  include wordpress

  $wordpress_dir = "${wordpress_dir}/wordpress"

  file { '/etc/php5/fpm/conf.d/wordpress.conf':
    content => template('php5/wordpress.conf.erb'),
    require => Package['php5-fpm'],
    notify => Service['php5-fpm']
  }
}
