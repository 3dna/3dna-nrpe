# == Define: nrpe::command::check_disk
#
# defines a nrpe check_disk for a disk device
# effectively a wrapper around 
#
# === Parameters
#
# [*pretty_name*]
#   the 'pretty' name. really more the sanitized name. defaults to simply $name with / -> _
# [*check_disk_plugin*]
#   the path to the check_disk plugin
# [*warning*]
#   warn if there is less than INTEGER units free
# [*critical*]
#   critical if there is less than INTEGER units free
# [*units*]
#   the units for the above values. defaults to undef (but the plugin defaults to MB)
# [*warning_percent*]
#   the warning threshhold of disk usage, in percent
# [*critical_percent*]
#   the critical threshhold of disk usage, in percent
# [*percent_used*]
#   whether the percentages are percent used or percent free.
#
#   the default behavior of the plugin is that it alerts based on the amount of free disk space
#   so, if your warn threshhold is 20 and crit is 10, that means it'll warn when you have 20% of disk space
#   free, and critical when you have 10% of disk space free.
#
#   I've always thought of these threshholds as percentage used, and so I added this parameter to allow you to
#   specify them as such.
#
#   Effectively, this tells the plugin that the threshhold is "100 - <threshhold>", so it's just syntactic sugar
#
#   this defaults to false, to mimic the behavior of the underlying plugin.
# [*inode_warning_percent*]
#   the warning threshhold of inode usage. you can 
# [*inode_critical_percent*]
# [*inode_percent_used*]
#   this parameter is the same as percent_used, but for inode threshholds. also defaults to false
# [*exact_match*]
#   only check for exact paths (the -E argument), defaults to false
#
# === Examples
#
# nrpe::command::check_disk { '/var/lib/postgresql':
#   warning_percent   => 75,
#   critical_percent  => 85,
#   percent_disk_used => true,
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
define nrpe::command::check_disk (
  $pretty_name            = regsubstr($name, '/', '_', 'G'),
  $check_disk_plugin      = "${nrpe::params::plugin_path}/check_disk",
  $warning                = undef,
  $critical               = undef,
  $warning_percent        = undef,
  $critical_percent       = undef,
  $percent_used           = false,
  $inode_warning_percent  = undef,
  $inode_critical_percent = undef,
  $inode_percent_used     = false,
  $exact_match            = false,
  $path                   = $name,
) {
  include nrpe::params

  if ($warning) {
    $warning_frag = "-w '${warning}'"
  }
  if ($critical) {
    $critical_frag = "-c '${critical}'"
  }
  if ($warning_percent) {
    if ($percent_used) {
      $real_warning_percent = 100 - $warning_percent
    } else {
      $real_warning_percent = $warning_percent
    }
    $warning_percent_frag = "-w '${real_warning_percent}%'"
  }
  if ($critical_percent) {
    if ($percent_used) {
      $real_critical_percent = 100 - $critical_percent
    } else {
      $real_critical_percent = $critical_percent
    }
    $critical_percent_frag = "-c '${real_critical_percent}%'"
  }
  if ($inode_warning_percent) {
    if ($inode_percent_used) {
      $real_inode_warning_percent = 100 - $inode_warning_percent
    } else {
      $real_inode_warning_percent = $inode_warning_percent
    }
    $inode_warning_percent_frag = "-W '${real_inode_warning_percent}%'"
  }
  if ($inode_critical_percent) {
    if ($inode_percent_used) {
      $real_inode_critical_percent = 100 - $inode_critical_percent
    } else {
      $real_inode_critical_percent = $inode_critical_percent
    }
    $inode_critical_percent_frag = "-K '${real_inode_critical_percent}%'"
  }
  if ($exact_match) {
    $exact_match_frag = '-E'
  }

  nrpe::command { "check_disk_${pretty_name}":
    command => "${check_disk_plugin} ${warning_frag} ${warning_percent_frag} ${critical_frag} ${critical_percent_frag} ${inode_warning_percent_frag} ${inode_critical_percent_frag} ${exact_match_frag} -p ${path}"
  }
}
