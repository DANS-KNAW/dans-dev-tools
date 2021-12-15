#!/usr/bin/env bash

for a in "$@"
do
  ARGS="$ARGS'$a' "
done

set -x
mvn exec:java -Ddans.default.config=etc/config.yml -Dexec.cleanupDaemonThreads=false -Dexec.args="$ARGS"
