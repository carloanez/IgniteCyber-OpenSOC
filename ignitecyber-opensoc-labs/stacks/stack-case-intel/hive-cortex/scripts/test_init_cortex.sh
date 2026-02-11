#! /usr/bin/env bash

source $(dirname $0)/output.sh

CORTEX_URL="https://127.0.0.1/cortex"

set -e
LOG_FILE=$(mktemp)

RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'x``
NC='\033[0m' # No Color

log() {
  echo "${BROWN}$1 ... ${NC}" | tee -a ${LOG_FILE} >&2
}

ok() {
    success  "OK" >&2
}

ko() {
    error "KO" >&2
}

if ! grep -Fxq "auth.method.basic = true" ./cortex/config/application.conf
then
  info " Updating configuration" 
  cat >> ./cortex/config/application.conf << _EOF_
auth.method.basic = true
_EOF_

  info "Restarting cortex" 
  docker compose restart cortex
fi

check() {
    expected=$1
    count=0
    shift
    while true
    do
      status_code=$(curl -k "$@" -s -o /dev/stderr -w '%{http_code}' 2>>${LOG_FILE}) || true
      if [ "${status_code}" = "${expected}" ]
      then
        break
      else
        error "got ${status_code}, expected ${expected}" >&2
        error "see more detail in $LOG_FILE" >&2
        count=$((${count}+1))
        if [ ${count} = 40 ]
        then
          exit 1
        else
          sleep 30
        fi
      fi
    done
}


# Check service is alive
check_service() {
    info "Checking if Cortex service is running"
    sleep 10
    check 200 "$CORTEX_URL/index.html"
}

create_index() {
    # Create the index
    info "Creating Cortex index"
    check 204 -XPOST "$CORTEX_URL/api/maintenance/migrate"
}

create_superadmin() {
    info "Creating Cortex superadmin user"
    check 201 "$CORTEX_URL/api/user" -H 'Content-Type: application/json' -d '
            {
              "login" : "admin",
              "name" : "admin",
              "roles" : [
                  "superadmin"
               ],
              "preferences" : "{}",
              "password" : "thehive1234",
              "organization": "cortex"
            }'
}

create_demo_org() {
    info "Creating Cortex demo organization"
    check 201 -u admin:thehive1234 "$CORTEX_URL/api/organization" -H 'Content-Type: application/json' -d '
        {
          "name": "demo",
          "description": "demo organization"
        }'
}

create_demo_thehive() {
    info "Creating thehive user"
    check 201 -u admin:thehive1234 "$CORTEX_URL/api/user" -H 'Content-Type: application/json'  -d '
        {
          "login" : "thehive",
          "name" : "thehive",
          "roles" : [
              "read",
              "analyze",
              "orgadmin"
           ],
          "password" : "thehive1234",
          "organization": "demo"
        }'
}




update_thehive_configuration() {
    info "Creating thehive api key"
    key=$(curl -k -s -u admin:thehive1234 "$CORTEX_URL/api/user/thehive/key/renew" -d '')
    echo $key > /tmp/cortex_key
    check 200 "$CORTEX_URL/api/user/thehive" -H 'Content-Type: application/json' \
        -H "Authorization: Bearer $key"
}

activate_analyzer() {
    if [ "$2" ]
    then
      data="$2"
    else  
      data='{
              "configuration": {
                "auto_extract_artifacts":false,
                "check_tlp":true,
                "max_tlp":2,
                "check_pap":true,
                "max_pap":2
                },
              "jobCache":10,
              "jobTimeout":30,
              "name": '\"$1\"'
          }'
    fi


    status_code=$(curl -k -s -u thehive:thehive1234 "$CORTEX_URL/api/organization/analyzer/$1" \
        -H 'Content-Type: application/json' -d "$data" -o /dev/null -w '%{http_code}' ) 

    if [ "${status_code}" = "201" ]
    then
        success "$1 activated"
    else
        error "Activating $1 failed"
    fi

    }

check_service
create_index
create_superadmin
create_demo_org
create_demo_thehive
update_thehive_configuration
activate_analyzer Abuse_Finder_3_0
activate_analyzer CIRCLHashlookup_1_1
activate_analyzer CyberCrime-Tracker_1_0
activate_analyzer DomainMailSPFDMARC_1_1
activate_analyzer DShield_lookup_1_0
activate_analyzer FileInfo_8_0 '{ 
  "name": "FileInfo_8_0",
  "configuration": {
    "manalyze_enable": false,
    "manalyze_enable_docker": false,
    "manalyze_enable_binary": false,
    "auto_extract_artifacts": true,
    "check_tlp": false,
    "max_tlp": 2,
    "check_pap": false,
    "max_pap": 2
  },
  "jobCache": 0
}'
activate_analyzer EmlParser_2_1 '{ 
  "name": "EmlParser_2_1",
  "configuration": {
    "email_visualisation": true,
    "auto_extract_artifacts": true,
    "check_tlp": false,
    "max_tlp": 2,
    "check_pap": false,
    "max_pap": 2
  },
  "jobCache": 0
}'
activate_analyzer Fortiguard_URLCategory_2_1
activate_analyzer GoogleDNS_resolve_1_0_0
activate_analyzer Inoitsu_1_0
activate_analyzer MaxMind_GeoIP_4_0
activate_analyzer Maltiverse_Report_1_0
activate_analyzer StopForumSpam_1_0
activate_analyzer TeamCymruMHR_1_0
activate_analyzer Threatcrowd_1_0
activate_analyzer UnshortenLink_1_2
activate_analyzer URLhaus_2_0
activate_analyzer Urlscan_io_Search_0_1_1


if grep -Fxq "auth.method.basic = true" ./cortex/config/application.conf
then
  sed -i '/auth.method.basic = true/d' ./cortex/config/application.conf 
  docker compose restart cortex 
fi