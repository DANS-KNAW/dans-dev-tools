#!/usr/bin/env bash
#
# Copyright (C) 2021 DANS - Data Archiving and Networked Services (info@dans.knaw.nl)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if [ -d home ]; then
  echo "ERROR: this project contains a 'home' directory. It is probably a legacy project. Use the run-*.sh scripts instead."
  exit
fi

for a in "$@"
do
  ARGS="$ARGS'$a' "
done

if [ -z $QUIET ]; then
  QUIET=""
  set -x
fi

mvn exec:java $QUIET -Ddans.default.config=etc/config.yml -Dexec.cleanupDaemonThreads=false -Dexec.args="$ARGS"
