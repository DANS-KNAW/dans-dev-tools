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

PLAYBOOK=src/main/ansible/rebuild-repo.yml
INVENTORY=.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory
export ANSIBLE_CONFIG=$(pwd)/src/main/ansible/ansible.cfg

CONTINUE=1

if [ ! -f $PLAYBOOK ]; then
    echo "Need the ansible playbook $PLAYBOOK to execute this task."
    CONTINUE=0
fi

if [ ! -f $INVENTORY ]; then
    echo "Need the ansible inventory file at $INVENTORY."
    echo "(This should be created automatically after 'vagrant up'.)"
    CONTINUE=0
fi

if (( ! $CONTINUE )); then
    echo "Cannot continue before the problem(s) mentioned above is/are resolved."
    exit 1
fi

if [ -f $ANSIBLE_CONFIG ]; then
    echo "Using config in $ANSIBLE_CONFIG"
else
    echo "WARNING: ansible config not found at $ANSIBLE_CONFIG. Proceeding with default ansible configuration."
fi

ansible-playbook $PLAYBOOK -i $INVENTORY
