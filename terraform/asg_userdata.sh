#!/bin/bash

# Mount EFS
fsname=fs-093de1afae7166759.efs.us-east-1.amazonaws.com # You must change this value to represent your EFS DNS name.
mkdir /efs
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $fsname:/ /efs

# install and set up Flask
apt-get update -y && apt-get upgrade -y 
apt-get install python3-flask mysql-client mysql-server python3-pip python3-venv -y 
apt-get install sox ffmpeg libcairo2 libcairo2-dev -y 
apt-get install python3-dev default-libmysqlclient-dev build-essential -y 

# Clone the app
git clone https://github.com/Kelvinskell/terra-tier.git
cd /terra-tier

# setup virtual environment
python3 -m venv venv
source venv/bin/activate

# Run Flask Application
pip install -r requirements.txt
export FLASK_APP=run.py
export FLASK_ENV=production
flask run -p 5000