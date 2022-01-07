#!/bin/bash
bootstrapDir=$PWD
bootstrap=$0

echo Bootstrap = $bootstrap
echo \$0 = $0

# Ensure script is running under root
if [ "$EUID" -ne 0 ]
  then
  echo WARNING: NOT ROOT OR SUDO, CHECKING USER $(whoami) FOR SUDO ACCESS 2>&1 | tee -a sshConnectBootstrap.log
  if [ "$(getent group wheel | grep $(whoami))" = "" ]
    then
      echo $(whoami) HAS NO SUDO ACCESS 2>&1 | tee -a wordpressBootstrap.log
  else
      echo $(whoami) HAS SUDO 2>&1 | tee -a sshConnectBootstrap.log
      #INITIAL BASIC TOOLS INSTALL
      echo updating System
      sudo yum update -y

      #INSTALL GIT
      echo installing git if not installed
      sudo yum install git -y
  fi
else
   echo UPDATING SYSTEM AS ROOT
   #INITIAL BASIC TOOLS INSTALL
   echo updating System
   yum update -y

   #INSTALL GIT
   echo installing git if not installed
   yum install git -y
fi

# SETUP ENVIRONMENT AND PARAMETERS
sshConnectDir=$PWD
pkg=SSH_CONNECT
gitRepo="linux-scripts-utils-gitHub-sshConnect.git"
installDir="/tmp/scripts/utils/$pkg"
remoteHostName=gitHub

if [ -f ~/.ssh/$gitHub ]; then
   clone="git clone git@github.com:RMelanson/"
else
   clone="git clone https://github.com/RMelanson/"
fi

# Clone $pkg
echo Executing $clone$gitRepo $installDir
$clone$gitRepo $installDir
# MAKE ALL SHELL SCRIPTS EXECUTABLE TO ROOT ONLY
find . -name "*.sh" -exec chmod 700 {} \;

# Setup Project
echo "BOOTSTRAP EXECUTING: ./setup.sh $* 2>&1| tee setup.log"
./setup.sh $* 2>&1| tee setup.log

cd $bootstrapDir

# Setup $pkg
cd $bootstrapDir
