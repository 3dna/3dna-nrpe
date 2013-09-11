# == Define: nrpe::plugin
#
# manages a nrpe plugin
#
# glorified wrapper around file{} really, but provides some abstraction
#
# === Parameters
#
# [*content*]
#   the contents of the plugin
# [*source*]
#   the source of the plugin
# [*nrpe_only*]
#   can only the nrpe user read/write/execute this file? defaults to false
# [*ensure*]
#   passed directly through to the file{} resource
#
# === Examples
#
# nrpe::command { "check_load":
#   command => '/usr/lib/nagios/plugins'
# }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
define nrpe::plugin (
  $content   = undef,
  $source    = undef,
  $ensure    = undef,
  $nrpe_only = false,
) {
  include nrpe::params

  # simple validation
  if (!$content and !$source) {
    fail("you must specify a source *or* content argument")
  }

  case $nrpe_only {
    true: {
      $user  = $nrpe::params::nrpe_user
      $group = $nrpe::params::nrpe_group
      $mode  = 0700
    }
    default: {
      $user  = undef
      $group = undef
      $mode  = undef
    }
  }

  file { "${nrpe::params::plugin_path}/${name}":
    ensure  => $ensure,
    source  => $source,
    content => $content,
    user    => $user,
    group   => $group,
    mode    => $mode,
  }
}
