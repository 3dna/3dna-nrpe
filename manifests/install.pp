# == Class: nrpe::install
#
# installs the package for nrpe
#
# === Parameters
#
# [*package_name*]
#   allows you to override the name of the package for nrpe
#   default is OS specific and comes from nrpe::params
#
# === Authors
#
# Jeremy Kitchen <jeremy@nationbuilder.com>
#
# === Copyright
#
# Copyright 2013 3dna Corp.
#
class nrpe::install (
  $package_name = $nrpe::params::package_name,
) inherits nrpe::params {
  package { $package_name:
    ensure => present,
  }
}
