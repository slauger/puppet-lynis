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
