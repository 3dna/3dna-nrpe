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
# [*plugin_path*]
#   specify the directory to place the plugin in
#
# === Examples
#
# nrpe::command { "check_load":
#   command => '/usr/lib/nagios/plugins'
# }
#
# === Authors
#
# Jeremy Kitchen <jeremy@nationbuilder.com>
#
# === Copyright
#
# Copyright 2013 3dna Corp
#
define nrpe::plugin (
  $content     = undef,
  $source      = undef,
  $ensure      = undef,
  $nrpe_only   = false,
  $plugin_path = $nrpe::params::plugin_path,
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
      $mode  = 0755
    }
  }

  file { "${plugin_path}/${name}":
    ensure  => $ensure,
    source  => $source,
    content => $content,
    user    => $user,
    group   => $group,
    mode    => $mode,
  }
}
