# == Define: nrpe::command
#
# specifies a check command to add to the nrpe daemon
#
# === Parameters
#
# [*command*]
#   the command to run.
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
) {
  include nrpe::params

  file { "${nrpe::params::conf_d_dir}/${name}.cfg":
    content => "command[${name}]=${command}",
  }
}
