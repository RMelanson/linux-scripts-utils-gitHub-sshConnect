#!/bin/bash

# SETUP THE ENVIRONMENT
setupName=setup.sh
echo "$setupName: EXECUTING: . ./env/setEnv.sh $*"
. ./env/setEnv.sh $*

# COPY RESTORE 
cp $pkg_RESTORE.sh ..

# install git libraries
yum install git -y

# Add github access keys
./sshConfig.sh
