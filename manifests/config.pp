# == Class: nrpe::config
#
# installs the nrpe config file
#
# === Parameters
#
# parameters here are taken from the default /etc/nagios/nrpe.cfg file installed on ubuntu
# as are their defaults.
#
# anything which looks to be sorta OS-specific gets pushed back to a nrpe::params and included that way
#
# it's of course overridable via hiera
#
# [*default_commands*]
#   this enables the default commands that come installed in the config file on ubuntu
#   they will simply be included as nrpe::command resources, so have at!
#
# === Examples
#
# in your manifest:
# include nrpe
#
# in hiera:
# nrpe::config::allowed_hosts: 
#   - 10.1.2.3
#   - 10.2.3.4
# nrpe::config::command_timeout: 45
# nrpe::config::server::ddress: 0.0.0.0
#
# === Authors
#
# Jeremy Kitchen <jeremy@nationbuilder.com>
#
# === Copyright
#
# Copyright 2013 3dna Corp
#
class nrpe::config (
  # straight out of the config file
  $log_facility = 'daemon',
  $pid_file     = $nrpe::params::pid_file,
  $server_port  = 5666,
  $server_address = undef,
  $nrpe_user    = $nrpe::params::nrpe_user,
  $nrpe_group   = $nrpe::params::nrpe_group,
  $allowed_hosts = '127.0.0.1',
  $dont_blame_nrpe = false,
  $command_prefix = undef,
  $debug = false,
  $command_timeout = 60,
  $connection_timeout = 300,
  $allow_weak_random_seed = undef,
  $include = undef,
  $includedir = undef,

  # optional bits
  $default_commands = true,
  $local_cfg = $nrpe::params::local_config,
) inherits nrpe::params {
  # config file
  $conf_d_dir = $nrpe::params::conf_d_dir

  file { $nrpe::params::config_file:
    content => template('nrpe/nrpe.cfg.erb'),
  }

  file { $conf_d_dir:
    ensure => directory,
    purge  => true,
  }

  if ($default_commands) {
    nrpe::command {
      'check_users':
        command => "${nrpe::params::plugin_path}/check_users -w 5 -c 10";
      'check_load':
        command => "${nrpe::params::plugin_path}/check_load -w 15,10,5 -c 30,25,20";
      'check_hda1':
        command => "${nrpe::params::plugin_path}/check_disk -w 20% -c 10% -p /dev/hda1";
      'check_zombie_procs':
        command => "${nrpe::params::plugin_path}/check_procs -w 5 -c 10 -s Z";
      'check_total_procs':
        command => "${nrpe::params::plugin_path}/check_procs -w 150 -c 200";
    }
  }
}
