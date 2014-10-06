#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# usage message
usage(){
	echo "Usage: $0 <coordinator id> <action>"
	exit 1
}

# check for parameter (coordiator id)
[[ $# -ne 2 ]] && usage

source "config/config.ini"
OOZIE_COORDINATOR_ID=$1
OOZIE_COORDINATOR_ACTION_ID=$2

echo $OOZIE_COORDINATOR_ID
echo $OOZIE_COORDINATOR_ACTION_ID

# rerun given coordinator actions
#${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -rerun ${OOZIE_COORDINATOR_ID} -action ${OOZIE_COORDINATOR_ACTION_ID}
