#!/usr/bin/env bash

MARATHON_HOST="${1-localhost}"

marathon_launch() {
  curl -X POST --socks5-hostname localhost "http://${MARATHON_HOST}:8080/v2/apps" -d @$2 -H 'Content-type: application/json'
}

marathon_launch_group() {
  curl -X POST --socks5-hostname localhost "http://${MARATHON_HOST}:8080/v2/groups" -d @$2 -H 'Content-type: application/json'
}

alias ml='marathon_launch'
alias mlg='marathon_launch_group'