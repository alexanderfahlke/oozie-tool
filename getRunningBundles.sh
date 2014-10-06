#!/usr/bin/env bash

if [ ! -f config/config.ini ]; then
	echo "config.ini not found!"
	exit 2
fi
source "config/config.ini"

# get all running bundles
OOZIE_RUNNING_BUNDLES=$(${OOZIE_BIN} jobs -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -jobtype bundle | grep RUNNING | awk '{print $1}')

# run script for getting the coordinators for each bundle
for bid in ${OOZIE_RUNNING_BUNDLES[@]}
do
	./getCoordinatorsByBundleID.sh ${bid}
done
