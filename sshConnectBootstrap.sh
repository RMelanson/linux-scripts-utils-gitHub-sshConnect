#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root or under sudo"
  exit -1
fi

#INITIAL BASIC TOOLS INSTALL
yum update -y

#INSTALL GIT
yum install git -y

# SETUP ENVIRONMENT AND PARAMETERS
sshConnectDir=$PWD
pkg=SSH_CONNECT
gitRepo="linux-scripts-utils-gitHub-sshConnect.git"
installDir="/tmp/scripts/utils/$pkg"

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

# MAKE ALL SHELL SCRIPTS EXECUTABLE TO ROOT ONLY
find . -name "*.sh" -exec chmod 700 {} \;

# Setup Project
./setup.sh 2>&1| tee setup.log

cd $sshConnectDir
