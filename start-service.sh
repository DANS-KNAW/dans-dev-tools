#!/usr/bin/env bash

set -x
MAVEN_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,address=8000,suspend=n" \
start.sh server etc/config.yml
