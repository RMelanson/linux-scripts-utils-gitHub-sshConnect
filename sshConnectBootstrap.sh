#!/bin/bash

# SETUP ENVIRONMENT AND PARAMETERS
sshConnectDir=$PWD
pkg=SSH_CONNECT
gitRepo="linux-scripts-utils-gitHub-sshConnect.git"
installDir="/tmp/scripts/utils/$pkg"/
remoteHostName=gitHub

echoLog(){
 echo $* 2>&1 | tee -a setup.log
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

strInFile(){
   str=$1
   fname=$2
   echo Searching for String $str in File $fname
   echo EXECUTING: cat $fname \| -c $str
   found=$(cat $fname | grep -c $str)
   echo string found = $found
  [ $found -eq 0 ]
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
   echoLog Updating System: execute_as_root yum update -y;
   execute_as_root yum update -y
}

install_git(){
   echoLog Installing git;
   execute_as_root yum install git -y
}

configure_remote_ssh_access(){
  ssh_key_name=$1
  remote_host=$2
  echoLog ECECUTING configure_remote_ssh_access $*
  ssh-keygen -t rsa -N "" -f ~/.ssh/$ssh_key_name
  echo "host "$remote_host                  >> ~/.ssh/config
  echo " HostName "$remote_host             >> ~/.ssh/config
  echo " IdentityFile ~/.ssh/"$ssh_key_name >> ~/.ssh/config
  echo " User git "                         >> ~/.ssh/config
  echo " passwordAuthentication no"         >> ~/.ssh/config
  chmod 600 ~/.ssh/config
}

update_bashrc() {
  # Add ssh-agent to bashrc if not already installed for load on startup
  str=$1"
  fname=$2
  if strInFile $str $fname; then
     echoLog $str not contained in file
   
  else
     echoLog $str is in file at least once
     echoLog ssh-agent not found, Adding ssh-agent to .bashrc starup script
     echoLog EXECUTING "echo 'eval \$("ssh-agent")' >> $fname"
     echo 'if [ "$PS1" ]; then' >> $fname
     echo '  eval $("ssh-agent")' >> $fname
     echo 'fi' >> $fname
  fi

  echoLog "<Copy the following ssh public (~/.ssh/$ssh_host_key).pub key to the remote authorized keys keys>"
  cat ~/.ssh/$ssh_key_name.pub
}

update_system
install_git
configure_remote_ssh_access gitHub gitHub.com
update_bashrc "ssh-agent" "~/.bashrc"
