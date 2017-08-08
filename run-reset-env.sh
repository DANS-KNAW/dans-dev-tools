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

APPHOME=home
DATADIR=data
INIT_DEBUG_ENV_SCRIPT=./debug-init-env.sh
set -e

rm -fr $APPHOME
cp -r src/main/assembly/dist $APPHOME
cp src/test/resources/debug-config/* $APPHOME/cfg/

if [ -e $DATADIR ]; then
    DATADIR_BACKUP=$DATADIR-$(date  +"%Y-%m-%d@%H:%M:%S")
    echo -n "Backing up existing data directory to $DATADIR_BACKUP..."
    mv $DATADIR $DATADIR_BACKUP
    echo "OK"
fi

mkdir $DATADIR

if [ -f $INIT_DEBUG_ENV_SCRIPT ]; then
    echo "START: project specific initialization in $INIT_DEBUG_ENV_SCRIPT..."
    source $INIT_DEBUG_ENV_SCRIPT
    echo "DONE: project specific initialization."
    echo
fi

echo "The debug environment has been reinitialized."

echo "Application home directory at: $APPHOME"
echo "Data and logging directory at: $DATADIR"
