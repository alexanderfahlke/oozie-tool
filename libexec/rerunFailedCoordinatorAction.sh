#!/bin/bash

# usage message
usage(){
	echo "Usage: $0 <coordinator id> <action>"
	exit 1
}

# check for parameter (coordinator id)
[[ $# -ne 2 ]] && usage

if [ ! -f config/config.ini ]; then
	echo "config.ini not found!"
	exit 2
fi
source "config/config.ini"

OOZIE_COORDINATOR_ID=$1
OOZIE_COORDINATOR_ACTION_ID=$2

# rerun given coordinator actions
${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -rerun ${OOZIE_COORDINATOR_ID} -action ${OOZIE_COORDINATOR_ACTION_ID}
