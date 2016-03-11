#!/usr/bin/env bash

marathon_launch() {
  echo "running marathon launcher helper script:"
  echo "curl -X POST http://localhost:8080/v2/apps -d @$1 -H 'Content-type: application/json'"
  curl -X POST http://localhost:8080/v2/apps -d @$1 -H 'Content-type: application/json'
}

marathon_launch_group() {
  echo "running marathon launcher helper script:"
  echo "curl -X POST http://localhost:8080/v2/groups -d @$1 -H 'Content-type: application/json'"
  curl -X POST http://localhost:8080/v2/groups -d @$1 -H 'Content-type: application/json'
}

alias ml='marathon_launch'
alias mlg='marathon_launch_group'
