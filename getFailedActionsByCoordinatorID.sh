#!/bin/bash

# usage message
usage(){
	echo "Usage: $0 <coordinator id>"
	exit 1
}

# check for parameter (coordiator id)
[[ $# -ne 1 ]] && usage

OOZIE_COORDINATOR_ID=$1

if [ ! -f config/config.ini ]; then
	echo "config.ini not found!"
	exit 2
fi
source "config/config.ini"

# get all coordinator actions from the given coordinator
OOZIE_FAILED_ACTIONS=$(${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -info ${OOZIE_COORDINATOR_ID} | grep -vP "SUCCEEDED|WAITING|RUNNING|READY|--+" | cut -f1 -d " " | grep -oP "[0-9]+$" | sort -nu | sed 's/$/,/' | tr -d '\n' | sed 's/,$//')

# check if there are any actions to rerun
if [ ! -z ${OOZIE_FAILED_ACTIONS} ]
then
	# get the coordinator name
	OOZIE_COORDINATOR_NAME=$(${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -info ${OOZIE_COORDINATOR_ID} | grep "Job Name" | awk '{print $4}')

	echo "./rerunFailedCoordinatorAction.sh ${OOZIE_COORDINATOR_ID} ${OOZIE_FAILED_ACTIONS} # ${OOZIE_COORDINATOR_NAME}"
fi

