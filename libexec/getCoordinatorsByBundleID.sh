#!/usr/bin/env bash

# Copyright 2014 Alexander Fahlke
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# usage message
usage(){
	echo "Usage: $0 <oozie bundle id>"
	exit 1
}

# check for parameter (bundle id)
[[ $# -lt 1 ]] && usage

OOZIE_BUNDLE_ID_LIST=$1
BUNDLE_FILTER=$2

if [ ! -f "${OOZIE_TOOL_CONF_DIR}/config.ini" ]; then
	echo "config.ini not found!"
	exit 2
fi
source "${OOZIE_TOOL_CONF_DIR}/config.ini"

IFS=', ' read -r -a array <<< "$OOZIE_BUNDLE_ID_LIST"
for OOZIE_BUNDLE_ID in "${array[@]}"
do
# print currently checked bundle name
OOZIE_BUNDLE_NAME=$(${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -info "$OOZIE_BUNDLE_ID" | grep "Job Name" | awk '{print $4}')
if [[ -n "$BUNDLE_FILTER" ]]; then
    if [[ "${OOZIE_BUNDLE_NAME}" == *"${BUNDLE_FILTER}"* ]]; then
	    exit 0
    fi
fi
echo -e "\e[00;34mChecking: ${OOZIE_BUNDLE_NAME} (${OOZIE_BUNDLE_ID})\e[00m"
echo "--------------------------------------------------------------------------------"

# get all coordinators from the given bundle
OOZIE_COORDINATOR_IDS=$(${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -info "$OOZIE_BUNDLE_ID" | grep 'RUNNING' | grep -oP "^[0-9]+.*?-C")

# run script for getting the failed actions
failed="false";
for cid in ${OOZIE_COORDINATOR_IDS[@]}
do
	${OOZIE_TOOL_LIBEXEC_DIR}/getFailedActionsByCoordinatorID.sh ${cid}
	if [ $? == 255 ];then failed="true"; fi
done

if [ $failed == "false" ]; then
	echo -e "\e[00;32mOK\e[00m";
fi


echo ""
done
