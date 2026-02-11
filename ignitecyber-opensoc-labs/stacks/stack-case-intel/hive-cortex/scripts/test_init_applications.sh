#! /usr/bin/env bash

## This program initialise and configure Cortex and TheHive with sample data. This allows to check that everything works fine.
## Reset the application stack by running the command: bash ./scripts/reset.sh

source $(dirname $0)/output.sh

## Initialize Cortex
info "Initializing Cortex"
bash $(dirname $0)/test_init_cortex.sh

## initialize TheHive
info "Initializing TheHive"
bash $(dirname $0)/test_init_thehive.sh

## System hostname
SYSTEM_HOSTNAME=$(uname -n)

REPORT="
Cortex has been initialized with following accounts:

* Cortex URL: https://${SYSTEM_HOSTNAME}/cortex
* Administrator:
  Login: admin
  Password: thehive1234

* An Organisation is also created with an orgadmin account:
  Login: thehive
  Password: thehive1234


TheHive has been initialized with following accounts:

* TheHive URL: https://${SYSTEM_HOSTNAME}/thehive
* Administrator:
  Login: admin@thehive.local
  Password: secret

* A user named thehive has been created and is org-admin of the organisation named demo:
  Login: thehive@thehive.local
  Password: thehive1234


TheHive is already integrated with Cortex, and few analyzers are enabled by default.
"


echo -e "${REPORT}"
