#!/bin/bash

# HTTP WEB CONFIGURATION PARAMETERS
pkg=SSH_CONNECT
bootstrap="sshConnectBootstrap.sh"

gitRepo="linux-scripts-utils-gitHub-sshConnect"
remoteHostName="gitHub"

#SET UP INSTALLATION DIRECTORY`
pkg=SSH_CONNECT
scriptType="utils"
parentDir="/tmp/scripts/$scriptType/"
installDir="$parentDir/$pkg"

pkgOwner=ec2-user

echo Setting External Args
echo These Arguments Overwrite Default Argument Settings
for arg in "$@"; do
  echo setArgs EXECUTING: export $arg
  export $arg
done
