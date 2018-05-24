#!/bin/bash
sshConnectDir=$PWD

#INITIAL BASIC TOOLS INSTALL
yum update -y

#INSTALL GIT
yum install git -y

#Set Cloning Properties
pkg=Web
gitRepo="linux-scripts-utils-gitHub-sshConnect"
installDir="/tmp/scripts/utils/sshConnect"
if [ -f ~/.ssh/gitHub.key ]; then
   clone="git clone git@github.com:RMelanson/"
else
   clone="git clone https://github.com/RMelanson/"
fi

# Clone $pkg
echo Executing $clone$gitRepo $installDir
$clone$gitRepo $installDir

# Setup $pkg
cd $installDir
. ./setup.sh

cd $sshConnectDir
