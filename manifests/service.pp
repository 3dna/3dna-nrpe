# == Class: nrpe::service
#
# manage the nrpe service
#
# === Parameters
#
# [*service_name*]
#   allows you to override the name of the service. default is OS specific and defined in nrpe::params
# [*enable*]
#   whether or not to enable the service at boot. defaults to true
# [*ensure*]
#   comes from the puppet service ensure field. defaults to undef
#
# === Authors
#
# Jeremy Kitchen <jeremy@nationbuilder.com>
#
# === Copyright
#
# Copyright 2013 3dna Corp
#
class nrpe::service (
  $service_name = $nrpe::params::service_name,
  $enable       = true,
  $ensure       = undef,

) inherits nrpe::params {
  service { $service_name: 
    ensure => $ensure,
    enable => $enable,
  }
}
