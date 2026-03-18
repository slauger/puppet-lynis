# @summary Configures the Lynis cron job for periodic security audits.
#
# This class manages a cron job that runs `lynis audit system` on a
# recurring schedule. When the hour or minute parameters are left
# undefined in the parent class, pseudo-random values derived from
# the node FQDN are used so that audit runs are spread evenly across
# the infrastructure.
#
# This class is managed by the main `lynis` class and should not be
# declared directly.
#
# @api private
#
# @example This class is included automatically by the lynis class
#   include lynis
#
class lynis::config {
  if ($lynis::cron_hour == undef) {
    $cron_hour = fqdn_rand(6, "${module_name}::cron_hour")
  } else {
    $cron_hour = $lynis::cron_hour
  }

  if ($lynis::cron_minute == undef) {
    $cron_minute = fqdn_rand(59, "${module_name}::cron_minute")
  } else {
    $cron_minute = $lynis::cron_minute
  }

  cron { 'lynis':
    ensure  => $lynis::cron_ensure,
    command => '/usr/sbin/lynis audit system &> /dev/null',
    user    => 'root',
    hour    => $cron_hour,
    minute  => $cron_minute,
  }
}
