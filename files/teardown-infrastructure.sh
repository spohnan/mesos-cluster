#!/usr/bin/env bash
#
# NOTE: Run the deploy action first to generate the config file from the template
#
# Usage: ./teardown-infrastrcture.sh
#                       --mesos      HOSTNAME_OF_MESOS_MASTER
#                       --socks      SOCKS_PROXY_PORT
#

# Parse arguments
declare -A ARGS
while [ $# -gt 0 ]; do
	# Trim the first two chars off of the arg name ex: --foo
	case "$1" in
		*) NAME="${1:2}"; shift; ARGS[$NAME]="${1-true}" ;;
	esac
	shift
done

# Get the ID of the Elasticsearch framework
ES_ID=$( \
    curl --silent --socks5-hostname "localhost:${ARGS[socks]}" \
    http://${ARGS[mesos]}:5050/master/frameworks | \
    jq --raw-output '.frameworks[] | select(.name == "elasticsearch") | .id' \
)

# Shut down the Elasticsearch framework
curl --silent --socks5-hostname "localhost:${ARGS[socks]}" \
    -XPOST http://t7-mesos-master-227cbf:5050/api/v1/scheduler \
    -d "{\"framework_id\":{\"value\": \"${ES_ID}\"},\"type\":\"TEARDOWN\"}" \
    -H Content-Type:application/json

# Terminate the infrastructure apps
curl --silent --socks5-hostname "localhost:${ARGS[socks]}" \
    -XDELETE "http://${ARGS[mesos]}:8080/v2/groups/i"
