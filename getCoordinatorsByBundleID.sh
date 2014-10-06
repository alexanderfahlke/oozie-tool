#!/bin/bash

# usage message
usage(){
	echo "Usage: $0 <oozie bundle id>"
	exit 1
}

# check for parameter (bundle id)
[[ $# -ne 1 ]] && usage

source "config/config.ini"
OOZIE_BUNDLE_ID=$1

# print currently checked bundle name
OOZIE_BUNDLE_NAME=$(${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -info ${OOZIE_BUNDLE_ID} | grep "Job Name" | awk '{print $4}')
echo "Checking: ${OOZIE_BUNDLE_NAME} (${OOZIE_BUNDLE_ID})"
echo "--------------------------------------------------------------------------------"

# get all coordinators from the given bundle
OOZIE_COORDINATOR_IDS=$(${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -info ${OOZIE_BUNDLE_ID} | grep -oP "^[0-9]+.*?-C")

# run script for getting the failed actions
for cid in ${OOZIE_COORDINATOR_IDS[@]}
do
	./getFailedActionsByCoordinatorID.sh ${cid}
done

echo ""
