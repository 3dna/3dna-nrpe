# == Class: nrpe::params
#
# OS specific parameters for the nrpe module
#
# === Authors
#
# Jeremy Kitchen <jeremy@nationbuilder.com>
#
# === Copyright
#
# Copyright 2013 3dna Corp
#
class nrpe::params {
  case $::osfamily {
    'Debian': {
      $pid_file = '/var/run/nagios/nrpe.pid'
      $nrpe_user = 'nagios'
      $nrpe_group = 'nagios'
      $config_file = '/etc/nagios/nrpe.cfg'
      $conf_d_dir = '/etc/nagios/nrpe.d'
      $package_name = 'nagios-nrpe-server'
      $extra_packages = ['nagios-plugins']
      $service_name = 'nagios-nrpe-server'
      $plugin_path = '/usr/lib/nagios/plugins'
    }
    default: {
      fail ("${::osfamily} is not yet supported")
    }
  }
}
