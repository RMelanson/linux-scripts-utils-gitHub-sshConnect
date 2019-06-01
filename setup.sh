#!/bin/bash
# Setup the required environment
. ./env/setEnv.sh $*

# COPY RESTORE 
cp $pkg_RESTORE.sh ..

# install git libraries
yum install git -y

# Add github access keys
./sshConfig.sh
