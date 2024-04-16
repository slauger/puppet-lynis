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
