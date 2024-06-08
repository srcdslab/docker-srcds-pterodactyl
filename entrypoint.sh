#!/bin/bash
##
#
# Variables
# GAME_PATH - Root game path
# STEAMCMD_PATH - SteamCMD path
#
##

if [ -z ${GAME_PATH} ];
then
    export GAME_PATH=/home/container;
fi

if [ -z ${STEAMCMD_PATH} ];
then
    export STEAMCMD_PATH="$GAME_PATH";
fi

cd "$GAME_PATH"

sleep 1

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Update Source Server
if [ ! -z ${SRCDS_APPID} ]; then
    if [ ! -z ${SRCDS_BETAID} ]; then
        if [ ! -z ${SRCDS_BETAPASS} ]; then
            ./$STEAMCMD_PATH/steamcmd/steamcmd.sh +login anonymous +force_install_dir "$GAME_PATH" +app_update ${SRCDS_APPID} -beta ${SRCDS_BETAID} -betapassword ${SRCDS_BETAPASS} +quit
        else
            ./$STEAMCMD_PATH/steamcmd/steamcmd.sh +login anonymous +force_install_dir "$GAME_PATH" +app_update ${SRCDS_APPID} -beta ${SRCDS_BETAID} +quit
        fi
    else
        ./$STEAMCMD_PATH/steamcmd/steamcmd.sh +login anonymous +force_install_dir "$GAME_PATH" +app_update ${SRCDS_APPID} +quit
    fi
fi

# Use system libraries
rm "${GAME_PATH}/bin/libstdc++.so.6" | true

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":$GAME_PATH$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
