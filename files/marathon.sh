#!/usr/bin/env bash
#
# NOTE: Run the deploy action first to generate the config file from the template
#
# Usage: ./marathon.sh
#           --marathon      HOSTNAME_OF_MARATHON_NODE
#           --type          [groups (default)|apps]
#           --socks         SOCKS_PROXY_PORT
#           --config        CONFIG_FILE
#
# Example:
#   1.) Create the deployment scripts: ./mesos.sh --prefix t8 --vars my-env.yml --action deploy
#   2.) Deploy:  deploy/marathon.sh --marathon t8-mesos-master-76301b --socks 5556 --config deploy/infrastructure.json
#

# Parse arguments
declare -A ARGS
# Defaults
ARGS[marathon]="localhost"
ARGS[type]="groups"
while [ $# -gt 0 ]; do
	# Trim the first two chars off of the arg name ex: --foo
	case "$1" in
		*) NAME="${1:2}"; shift; ARGS[$NAME]="${1-true}" ;;
	esac
	shift
done

if [ ! -z "${ARGS[socks]}" ]; then
    SOCKS_PROXY="--socks5-hostname localhost:${ARGS[socks]}"
fi

curl -X POST $SOCKS_PROXY "http://${ARGS[marathon]}:8080/v2/${ARGS[type]}" \
    -d "@${ARGS[config]}" -H 'Content-type: application/json'
