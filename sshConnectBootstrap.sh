#!/bin/bash

# SETUP ENVIRONMENT AND PARAMETERS
sshConnectDir=$PWD
pkg=SSH_CONNECT
gitRepo="linux-scripts-utils-gitHub-sshConnect.git"
installDir="/tmp/scripts/utils/$pkg"/
remoteHostName=gitHub

echoLog(){
 echo $* 2>&1 | tee setup.log
}
 
is_root_user(){
  [ $(id -u) -eq 0 ]
}

# is_root_user: Determine if current user is root (id = 0)
is_root_user(){
  [ $(id -u) -eq 0 ]
}

# is_sudo_user: Determine if current user is sudo user
is_sudo_user(){
  [ "$(getent group wheel | grep $(whoami))" != "" ]
}

# execute_as_root: execute as root if root user or has sudo access
execute_as_root(){
  echoLog "EXECUTING: "$@
  if is_root_user
  then {
    echoLog EXECUTING AS ROOT USER command $*
    $*
  }
  else {
    if is_sudo_user
    then {
      echoLog EXECUTING sudo $*
      sudo $*
    }
    else {
      echoLog NO ROOT OR SUDO ACCESS FOR USER $(whoami)
      echoLog COMMAND $*
      echoLog NOT EXECUTED UNDER ROOT
    }
    fi
  }
  fi
}
update_system(){
   echoLog("Updating System: execute_as_root yum update -y");
   execute_as_root yum update -y
}

install_git(){
   echoLog("Installing git");
   execute_as_root yum install git -y
}

configure_remote_ssh_access(){
  ssh-keygen -t rsa -N "" -f ~/.ssh/gitHub
  echo "host github.com"                 >> ~/.ssh/config
  echo " HostName github.com"            >> ~/.ssh/config
  echo " IdentityFile ~/.ssh/gitHub"     >> ~/.ssh/config
  echo " User git"                       >> ~/.ssh/config
  echo " passwordAuthentication no"      >> ~/.ssh/config
  chmod 600 ~/.ssh/config

  # Add ssh-agent to bashrc if not already installed for load on startup
  if grep -Fxq ~/.bashrc "ssh-agent"
  then
      echoLog ssh-agent found
  else
      echoLog ssh-agent not found, Adding ssh-agent to bashrc starup script
      echoLog EXECUTING "echo 'eval \$("ssh-agent")' >> ~/.bashrc"
      echo 'eval $("ssh-agent")' >> ~/.bashrc
  fi

  echoLog "<Copy the following ssh public (~/.ssh/gitHub.pub) key to the remote authorized keys keys>"
  cat ~/.ssh/gitHub.pub
}

update_system
install_git
configure_remote_ssh_access
