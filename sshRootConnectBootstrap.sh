#!/bin/bash
bootstrapDir=$PWD
bootstrap="sshRootConnectBootstrap.sh"

echo Bootstrap = $bootstrap
echo \$0 = $0

# Ensure script is running under root
if [ "$EUID" -ne 0 ]
  then
  echo WARNING: NOT ROOT OR SUDO, CHECKING USER $(whoami) FOR SUDO ACCESS 2>&1 | tee -a sshConnectBootstrap.log
  if [ "$(getent group wheel | grep $(whoami))" = "" ]
    then
      echo $(whoami) HAS NO SUDO ACCESS 2>&1 | tee -a wordpressBootstrap.log
      echo "ERROR: CANNOT PROCEED, MUST RUN AS ROOT OR UNDER SUDO" 2>&1 | tee -a sshConnectBootstrap.log
    else
      echo $(whoami) HAS SUDO 2>&1 | tee -a sshConnectBootstrap.log
      sudo $bootstrap $@
  fi
else
   if [ "$EUID" -ne 0 ]
   then
      sudo -n true 2/dev/null 2>&1
      passwordRequired=$?

      if [ "$passwordRequired" == "1" ]; then
          echo "Please run as root or under user with sudo access sudo"
      else
          sudo chmod +x $bootstrap
          sudo $bootstrap
      fi
      return 1
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
fi

# Setup $pkg
cd $bootstrapDir
