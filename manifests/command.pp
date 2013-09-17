# == Define: nrpe::command
#
# specifies a check command to add to the nrpe daemon
#
# === Parameters
#
# [*command*]
#   the command to run.
#   if the command is not fully qualified, the plugin_path will be prepended
# [*plugin_path*]
#   specify an alternate path to the plugin dir
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
define nrpe::command (
  $command,
  $plugin_path = $nrpe::params::plugin_path,
) {
  include nrpe::params

  if ($command !~ /^\//) {
    $real_command = "${plugin_path}/${command}"
  } else {
    $real_command = $command
  }

  file { "${nrpe::params::conf_d_dir}/${name}.cfg":
    content => "command[${name}]=${real_command}",
  }
}
