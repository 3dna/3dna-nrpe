# == Class: nrpe
#
# installs a nrpe server and nrpe commands
#
# === Parameters
#
# [*nrpe::install::package_name*]
#   the name of the package providing nrpe. default is OS specific and defined in nrpe::params
# [*nrpe::service::service_name*]
#   the name of the nrpe service. default is OS speciif and defined in nrpe::params
#
# see the nrpe::config class for information about config file parameters
#
# === Examples
#
# in your manifest:
# include nrpe
#
# in hiera:
# nrpe::install::package_name: nagios-nrpe-server
# nrpe::service::service_name: nagios-nrpe-server
# nrpe::config::allowed_hosts:
#   - 10.1.2.3
#
# === Authors
#
# Jeremy Kitchen <jeremy@nationbuilder.com>
#
# === Copyright
#
# Copyright 2013 3dna Corp
#
class nrpe inherits nrpe::params {
  include nrpe::install
  include nrpe::config
  include nrpe::service

  Class['nrpe::install'] -> Class['nrpe::config'] ~> Class['nrpe::service']
  Class['nrpe::install'] -> Nrpe::Command <| |> ~> Class['nrpe::service']

  anchor {
    'nrpe::begin':
      before => [Class['nrpe::install'],Class['nrpe::config']],
      notify => Class['nrpe::service'];
    'nrpe::end':
      require => Class['nrpe::service'];
  }
}
