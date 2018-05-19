#!/bin/bash
sshConnectDir=$PWD

#Set Cloning Properties
pkg=Web
gitRepo="linux-scripts-utils-gitHub-sshConnect"
installDir="/tmp/scripts/utils/sshConnect"
if [ "$1" = "ssh" ]; then
   clone="git clone git@github.com:RMelanson/"
else
   clone="git clone https://github.com/RMelanson/"
fi

# Clone $pkg
echo Executing $clone$gitRepo $installDir
$clone$gitRepo $installDir

exit 1

# Setup $pkg
cd $installDir
. ./setup.sh

cd $sshConnectDir
