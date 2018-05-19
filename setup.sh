#!/bin/bash
# Setup the required environment
. ./env/setEnv.sh

# install git libraries
yum install git -y

# Add github access keys
./generateKeys.sh
