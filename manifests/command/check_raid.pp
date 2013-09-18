# == Define: nrpe::command::check_raid
#
# defines a nrpe check_raid for a linux system
# 
# creating this for DRY portability across ubuntu
# 12.04 you use check_linux_raid which is in nagios-plugins-standard
# 13.04 you use check_raid which is in nagios-plugins-contrib
# these settings can be found in nrpe::params for porting concerns
#
# === Examples
#
# nrpe::command::check_raid { 'check_raid': }
#
# === Authors
#
# Jeremy Kitchen <jeremy@nationbuilder.com>
#
# === Copyright
#
# Copyright 2013 3dna Corp
#
define nrpe::command::check_raid (
  $check_raid_plugin  = $nrpe::params::check_raid_plugin,
  $check_raid_package = $nrpe::params::check_raid_package,
) {
  include nrpe::params

  nrpe::command { $name:
    command => "${check_raid_plugin}",
    require => Package[$check_raid_package],
  }
}
