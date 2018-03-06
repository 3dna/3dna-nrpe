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
      $_dist_release = scanf("${::lsbdistrelease}", "%i")

      case $::operatingsystem {
        'Ubuntu': {
          # in 13.04 the check_linux_raid was removed from nagios-plugins-standard,
          # renamed to check_raid, and moved into nagios-plugins-contrib. le SIGH
          if ($_dist_release >= 13) {
            $check_raid_plugin = 'check_raid'
            $check_raid_package = 'nagios-plugins-contrib'
          } else {
            $check_raid_plugin = 'check_linux_raid'
            $check_raid_package = 'nagios-plugins-standard'
          }
        }
        default: {
          fail ("${::operatingsystem} is not yet supported (check_raid bits, specifically)")
        }
      }
    }
    default: {
      fail ("${::osfamily} is not yet supported")
    }
  }
}
