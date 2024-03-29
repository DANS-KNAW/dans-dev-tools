#!/usr/bin/env bash
#
# Copyright (C) 2017 DANS - Data Archiving and Networked Services (info@dans.knaw.nl)
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

if [ -d etc ]; then
  echo "ERROR: this project contains an 'etc' directory. It is probably a new style project. Use the start-*.sh scripts instead."
  exit
fi


APPHOME=home

if [ -z $QUIET ]; then
    QUIET=""
fi

if [ -z $LOGBACK_OPTS ]; then
    LOGBACK_OPTS=""
fi

if [ -z $LOGBACK_CONFIG ]; then
    LOGBACK_CONFIG=$APPHOME/cfg/logback.xml
fi


for a in "$@"
do
  ARGS="$ARGS'$a' "
done

LC_ALL=en_US.UTF-8 \
mvn exec:java $QUIET -Dapp.home=$APPHOME \
                     -Dlogback.configurationFile=$LOGBACK_CONFIG \
                     -Dexec.args="$ARGS" $LOGBACK_OPTS
