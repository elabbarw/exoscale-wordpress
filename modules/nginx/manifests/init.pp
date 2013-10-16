# Install Apache

class nginx {

  package { 'nginx':
    ensure => present,
  }

  service { 'nginx':
    ensure  => running,
    require => Package['nginx'],
  }

  file { '/etc/nginx/nginx.conf':
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => '/etc/puppet/modules/nginx/files/nginx.default',
    require => Package['nginx'],
    notify => Service['nginx']
  }

  file { '/etc/nginx/fastcgi_params':
    owner => 'root',
    group => 'root',
    mode => '0644',
    source => '/etc/puppet/modules/nginx/files/fastcgi_params',
    require => Package['nginx'],
    notify => Service['nginx']
  }

  file { '/etc/nginx/sites-enabled/default':
    ensure => absent,
    require => Package['nginx']
  }

}

class nginx::wordpress {
  include wordpress
  include nginx
  
  $wordpress_dir = extlookup('wordpress-dir', '/opt')
  $server_names = extlookup("wordpress-server-names", "wordpress")

  file { '/etc/nginx/sites-enabled/wordpress.conf':
    content => template("nginx/wordpress.conf.erb"),
    require => File['/etc/nginx/nginx.conf'],
    notify => Service['nginx']
  }
}
