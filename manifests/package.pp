# @summary Installs the Lynis package.
#
# This class is managed by the main `lynis` class and should not be
# declared directly.
#
# @api private
#
# @example This class is included automatically by the lynis class
#   include lynis
#
class lynis::package {
  package { 'lynis':
    ensure => present,
  }
}
