#!/bin/bash

apt update
apt upgrade -y

# Mount EFS
fsname=fs-093de1afae7166759.efs.us-east-1.amazonaws.com # You must change this value to represent your EFS DNS name.

mkdir /efs
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $fsname:/ /efs

# install and set up Flask
apt install python3-venv
mkdir project-x && cd project-x
source venv/bin/activate
pip install flask