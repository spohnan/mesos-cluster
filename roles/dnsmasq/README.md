# Dnsmasq

An Ansible role for setting up Dnsmasq under CentOS/RHEL 7 as a simple DNS forwarder, and/or DHCP server. Specifically, the responsibilities of this role are to install the necessary packages and manage the configuration.

Configuring the firewall is outside the scope of this role. Use another role suitable for your distribution, e.g. [bertvv.el7](https://galaxy.ansible.com/bertvv/el7/).

If you like/use this role, please consider starring it. Thanks!


## Requirements

No specific requirements.

## Role Variables

None of the variables below are required, but you need to at least set `dnsmasq_listen_address` to make the service available on the network.

| Variable                 | Default   | Comments                                                                                                                                                                               |
| :---                     | :---      | :---                                                                                                                                                                                   |
| `dnsmasq_addn_hosts`     | -         | set this to specify a custom host file that should be read in addition to `/etc/hosts`.                                                                                                |
| `dnsmasq_authoritative`  | `false`   | when `true`, dnsmasq will function as an authoritative name server.                                                                                                                    |
| `dnsmasq_bogus_priv`     | `false`   | set this if Dnsmasq should not forward addresses in the non-routed address spaces.                                                                                                     |
| `dnsmasq_dhcp_hosts`     | -         | set this to reserve IP addresses for specific hosts. You should provide an array of hashes with keys `name` (optional), `mac` and `ip` for eachi reservation.                          |
| `dnsmasq_dhcp_ranges`    | -         | set this to enable the DHCP server. You should specify an array of hashes (with keys `start_addr`, `end_addr`, and `lease_time`) for each address pool. See the Example section below. |
| `dnsmasq_domain_needed`  | `false`   | set this if Dnsmasq should not forward local requests (i.e. without domain name).                                                                                                      |
| `dnsmasq_domain`         | -         | set the domain for Dnsmasq.                                                                                                                                                            |
| `dnsmasq_expand_hosts`   | `false`   | set this (and `dnsmasq_domain`) if you want to have a domain automatically added to simple names in a hosts-file.                                                                      |
| `dnsmasq_listen_address` | 127.0.0.1 | set this to specify the IP address of the interface that should listen to DNS/DHCP requests.                                                                                           |
| `dnsmasq_interface`      | -         | set this to specify the the interface that should listen to DNS/DHCP requests.                                                                                                         |
| `dnsmasq_option_router`  | -         | set this to specify the default gateway to be sent to clients.                                                                                                                         |
| `dnsmasq_port`           | -         | set this to listen on a custom port.                                                                                                                                                   |
| `dnsmasq_resolv_file`    | -         | set this to specify a custom `resolv.conf` file.                                                                                                                                       |
| `dnsmasq_server`         | -         | set this to specify the IP address of upstream DNS servers directly.                                                                                                                   |

## Dependencies

None, but role [bertvv.hosts](https://galaxy.ansible.com/bertvv/hosts/) may come in handy if you want an easy way to manage the contents of `/etc/hosts`.

## Example Playbook

Most Dnsmasq settings have sane defaults and don't have to be specified. The simplest configuration would be a DNS forwarder with default settings:

```Yaml
- hosts: server
  vars:
    listen_address: 192.168.0.2
  roles:
    - bertvv.dnsmasq
```

A more elaborate example, with DHCP can be found in the [test playbook](tests/test.yml).

## Testing

The `tests` directory contains tests for this role in the form of a Vagrant environment. The playbook [`test.yml`](tests/test.yml) applies the role to a VM, setting up a DNS forwarder and DHCP server.

The directory also contains a set of functional tests that validate whether the Dnsmasq service actually works. You can run the tests both from the host system and the VM by executing the script `runbats.sh`. When needed, the script will install [BATS](https://github.com/sstephenson/bats), a testing framework for Bash.

```
## From the host system:
$ ./runbats.sh
Running test /home/bert/CfgMgmt/roles/dnsmasq/tests/dns.bats
 ✓ The `dig` command should be installed
 ✓ Forward lookups
 ✓ Reverse lookups

 3 tests, 0 failures

## From the VM:
$ /vagrant/runbats.sh
Running test /vagrant/dns.bats
 ✓ The `dig` command should be installed
 ✓ Forward lookups
 ✓ Reverse lookups

3 tests, 0 failures
```

In the console transcript above, the output of installing BATS is not shown.

## See also

Debian/Ubuntu users can take a look at [Debops](https://galaxy.ansible.com/debops/)'s [Dnsmasq role](https://galaxy.ansible.com/debops/dnsmasq/).

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section. Pull requests are also very welcome. Preferably, create a topic branch and when submitting, squash your commits into one (with a descriptive message).

## License

Licensed under the 2-clause "Simplified BSD License". See [LICENSE.md](/LICENSE.md) for details.

## Author Information

Written by Bert Van Vreckem <bert.vanvreckem@gmail.com>

Contributions by:

- [Chris James](https://github.com/etcet)
- [David Wittman](https://github.com/DavidWittman)
