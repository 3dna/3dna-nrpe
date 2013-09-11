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
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
define nrpe::command (
  $command,
) {
  include nrpe::params

  file { "${nrpe::params::conf_d_dir}/${name}.cfg":
    content => "command[${name}]=${command}",
  }
}
