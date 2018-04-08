#!/bin/bash

. /plex-common.sh

#Workarround for arm64
if [ $ARCH_BUILD == "aarch64" ]; then

  apt-get update && apt-get install -y apt-transport-https

  curl -sL https://dev2day.de/pms/dev2day-pms.gpg.key | apt-key add -
  echo "deb https://dev2day.de/pms/ stretch main" >> /etc/apt/sources.list.d/pms.list
  apt-get update
  apt-get install plexmediaserver-installer:armhf

fi


echo "${TAG}" > /version.txt
if [ ! -z "${URL}" ]; then
  echo "Attempting to install from URL: ${URL}"
  installFromRawUrl "${URL}"
elif [ "${TAG}" != "beta" ] && [ "${TAG}" != "public" ]; then
  getVersionInfo "${TAG}" "" remoteVersion remoteFile

  if [ -z "${remoteVersion}" ] || [ -z "${remoteFile}" ]; then
    echo "Could not get install version"
    exit 1
  fi

  echo "Attempting to install: ${remoteVersion}"
  installFromUrl "${remoteFile}"
fi
