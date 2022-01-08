#!/bin/bash

# SETUP ENVIRONMENT AND PARAMETERS
sshConnectDir=$PWD
pkg=SSH_CONNECT
gitRepo="linux-scripts-utils-gitHub-sshConnect.git"
installDir="/tmp/scripts/utils/$pkg"
remoteHostName=gitHub

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
  if is_root_user
  then {
    echo EXECUTING AS ROOT USER command $*
    $*
  }
  else {
    if is_sudo_user
    then {
      echo EXECUTING AS SUDO USER $*
      sudo $*
    }
    else {
      echo NO ROOT OR SUDO ACCESS FOR USER $(whoami)
      echo COMMAND $*
      echo NOT EXECUTED UNDER ROOT
    }
    fi
  }
  fi
}
update_system(){
   execute_as_root yum update -y
}

install_git(){
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
      echo ssh-agent found
  else
      echo ssh-agent not found, Adding ssh-agent to bashrc starup script
      echo EXECUTING "echo 'eval \$("ssh-agent")' >> ~/.bashrc"
      echo 'eval $("ssh-agent")' >> ~/.bashrc
  fi

  echo "<Copy the following ssh public (~/.ssh/gitHub.pub) key to the remote authorized keys keys>"
  cat ~/.ssh/gitHub.pub
}

update_system
install_git
configure_remote_ssh_access
