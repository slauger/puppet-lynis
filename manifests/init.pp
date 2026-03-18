# @summary Installs and configures the Lynis security auditing tool.
#
# This class manages the installation of Lynis and sets up an optional
# cron job to perform periodic security audits of the system.
#
# @param cron_ensure
#   Whether the Lynis cron job should be present or absent.
#   Defaults to `present` (via Hiera).
#
# @param cron_minute
#   The minute at which the Lynis cron job should run. If left undefined,
#   a pseudo-random value derived from the node FQDN is used to spread
#   execution across nodes.
#   Defaults to `undef` (via Hiera).
#
# @param cron_hour
#   The hour at which the Lynis cron job should run. If left undefined,
#   a pseudo-random value derived from the node FQDN is used to spread
#   execution across nodes.
#   Defaults to `undef` (via Hiera).
#
# @example Basic usage with defaults
#   include lynis
#
# @example Disable the cron job
#   class { 'lynis':
#     cron_ensure => 'absent',
#   }
#
# @example Run the audit daily at 03:30
#   class { 'lynis':
#     cron_ensure => 'present',
#     cron_hour   => '3',
#     cron_minute => '30',
#   }
#
class lynis (
  Enum["present", "absent"] $cron_ensure,
  Optional[String] $cron_minute,
  Optional[String] $cron_hour,
) {
  contain 'lynis::package'
  contain 'lynis::config'

  Class['lynis::package']
  ->Class['lynis::config']
}
