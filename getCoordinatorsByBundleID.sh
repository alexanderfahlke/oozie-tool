#!/bin/bash

# usage message
usage(){
	echo "Usage: $0 <oozie bundle id>"
	exit 1
}

# check for parameter (bundle id)
[[ $# -ne 1 ]] && usage

OOZIE_BUNDLE_ID=$1

if [ ! -f config/config.ini ]; then
	echo "config.ini not found!"
	exit 2
fi
source "config/config.ini"

# print currently checked bundle name
OOZIE_BUNDLE_NAME=$(${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -info ${OOZIE_BUNDLE_ID} | grep "Job Name" | awk '{print $4}')
echo -e "\e[00;34mChecking: ${OOZIE_BUNDLE_NAME} (${OOZIE_BUNDLE_ID})\e[00m"
echo "--------------------------------------------------------------------------------"

# get all coordinators from the given bundle
OOZIE_COORDINATOR_IDS=$(${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -info ${OOZIE_BUNDLE_ID} | grep -oP "^[0-9]+.*?-C")

# run script for getting the failed actions
failed="false";
for cid in ${OOZIE_COORDINATOR_IDS[@]}
do
	./getFailedActionsByCoordinatorID.sh ${cid}
	if [ $? == 255 ];then failed="true"; fi
done

if [ $failed == "false" ]; then
	echo -e "\e[00;32mOK\e[00m";
fi


echo ""
