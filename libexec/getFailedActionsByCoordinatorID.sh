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
	echo "Usage: $0 <coordinator id>"
	exit 1
}

# check for parameter (coordiator id)
[[ $# -ne 1 ]] && usage

OOZIE_COORDINATOR_ID=$1

if [ ! -f "${OOZIE_TOOL_CONF_DIR}/config.ini" ]; then
	echo "config.ini not found!"
	exit 2
fi
source "${OOZIE_TOOL_CONF_DIR}/config.ini"

# get all coordinator actions from the given coordinator
OOZIE_FAILED_ACTIONS=$(${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -info ${OOZIE_COORDINATOR_ID} | grep -vP "SUCCEEDED|WAITING|RUNNING|READY|--+" | cut -f1 -d " " | grep -oP "[0-9]+$" | sort -nu | sed 's/$/,/' | tr -d '\n' | sed 's/,$//')

# check if there are any actions to rerun
if [ ! -z ${OOZIE_FAILED_ACTIONS} ]
then
	# get the coordinator name
	OOZIE_COORDINATOR_NAME=$(${OOZIE_BIN} job -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -info ${OOZIE_COORDINATOR_ID} | grep "Job Name" | awk '{print $4}')

	echo -e "\e[00;31m${OOZIE_TOOL_LIBEXEC_DIR}/rerunFailedCoordinatorAction.sh ${OOZIE_COORDINATOR_ID} ${OOZIE_FAILED_ACTIONS} # ${OOZIE_COORDINATOR_NAME}\e[00m"
	exit 255;
fi

