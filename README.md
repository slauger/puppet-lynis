# slauger-lynis

A Puppet module for installing and managing [Lynis](https://cisofy.com/lynis/), an open-source security auditing tool for Unix-based systems. This module installs the Lynis package and configures a cron job to run periodic system audits.

## Table of Contents

- [Setup / Requirements](#setup--requirements)
- [Usage](#usage)
- [Hiera Examples](#hiera-examples)
- [Reference](#reference)
  - [Classes](#classes)
  - [Parameters](#parameters)
- [Limitations](#limitations)
- [License](#license)

## Setup / Requirements

### Puppet Version

This module requires Puppet >= 7.24 and < 9.0.0.

### Supported Operating Systems

| Operating System | Supported Releases |
|---|---|
| CentOS | 7 |
| Oracle Linux | 7 |
| Red Hat Enterprise Linux | 8 |
| Scientific Linux | 7 |
| Debian | 10 |
| Ubuntu | 18.04 |

### Dependencies

This module has no external module dependencies. The `lynis` package must be available in a package repository configured on the target node.

## Usage

### Basic Usage

Include the module with default parameters:

```puppet
include lynis
```

This will install the `lynis` package and create a cron job that runs `lynis audit system` daily. By default, the cron hour and minute are randomized per node using `fqdn_rand` to spread the load across your infrastructure.

### Setting a Fixed Cron Schedule

To run the audit at a specific time (e.g., 03:30 every day):

```puppet
class { 'lynis':
  cron_hour   => '3',
  cron_minute => '30',
}
```

### Disabling the Cron Job

To install Lynis without scheduling automatic audits:

```puppet
class { 'lynis':
  cron_ensure => 'absent',
}
```

## Hiera Examples

### Default (randomized schedule)

```yaml
lynis::cron_ensure: present
lynis::cron_hour: ~
lynis::cron_minute: ~
```

### Fixed schedule at 02:15 daily

```yaml
lynis::cron_ensure: present
lynis::cron_hour: '2'
lynis::cron_minute: '15'
```

### Disable cron job

```yaml
lynis::cron_ensure: absent
```

## Reference

### Classes

#### `lynis`

Main class. Includes `lynis::package` and `lynis::config`.

#### `lynis::package`

Installs the `lynis` package. This class is managed by the main `lynis` class and should not be declared directly.

#### `lynis::config`

Manages the cron job for running Lynis system audits. This class is managed by the main `lynis` class and should not be declared directly.

The cron job runs the following command as root:

```
/usr/sbin/lynis audit system &> /dev/null
```

### Parameters

All parameters are set on the main `lynis` class.

#### `cron_ensure`

Controls whether the cron job is present or absent.

- **Type:** `Enum["present", "absent"]`
- **Default:** `present`

#### `cron_hour`

The hour at which the cron job runs. When set to `undef` (the default), the hour is randomized per node using `fqdn_rand(6)`, producing a value between 0 and 5.

- **Type:** `Optional[String]`
- **Default:** `undef`

#### `cron_minute`

The minute at which the cron job runs. When set to `undef` (the default), the minute is randomized per node using `fqdn_rand(59)`, producing a value between 0 and 58.

- **Type:** `Optional[String]`
- **Default:** `undef`

## Limitations

- The cron job output is discarded (`&> /dev/null`). Audit results are written to the Lynis log file (typically `/var/log/lynis.log`) and report file (typically `/var/log/lynis-report.dat`).
- The module does not manage custom Lynis profiles or configuration files.
- The `lynis` package must be available in a configured package repository on the target node. The module does not manage repository configuration.

## License

This module is released under the [MIT License](https://opensource.org/licenses/MIT).

Copyright (c) Simon Lauger
