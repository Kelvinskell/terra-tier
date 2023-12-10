#!/bin/bash

# Use Google's DNS
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# Force apt to use IPV4
apt-get -o Acquire::ForceIPv4=true update

# Change hostname
echo "project-x-app-server" > /etc/hostname

# Install efs-utils
apt-get install awscli -y
mkdir /efs
sudo apt-get -y install git binutils
git clone https://github.com/aws/efs-utils
cd /efs-utils
./build-deb.sh
apt-get -y install ./build/amazon-efs-utils*deb

# Mount EFS
fsname=$(aws efs describe-file-systems --region us-east-1 --creation-token project-x --output table |grep FileSystemId |awk '{print $(NF-1)}')
mount -t efs $fsname /efs

# Get DB credentials
DB=$(aws rds describe-db-instances --db-instance-identifier --region us-east-1 database-1 --output table |grep DBName |awk '{print $(NF-1)}')
HOST=$( aws rds describe-db-instances --db-instance-identifier --region us-east-1 database-1 --output table |grep Address |awk '{print $(NF-1)}')
ARN=$(aws secretsmanager list-secrets --region us-east-1 --filters "Key=tag-value, Values=project-x-rds-mysqldb-instance" --output table |grep ARN |awk '{print $(NF-1)}')
USER=$(aws secretsmanager get-secret-value --region us-east-1 --secret-id $ARN --output table |grep -w SecretString |awk '{print $3}' |cut -d: -f2 |sed 's/password//' |tr -d '",')
PRE_PASSWORD=$(aws secretsmanager get-secret-value --region us-east-1 --secret-id $ARN --output table |grep -w SecretString |awk '{print $3}' |cut -d: -f3 |tr -d '"')
PASSWORD=${PRE_PASSWORD%?}

# install and set up Flask
apt-get update -y && apt-get upgrade -y 
apt-get install python3-flask mysql-client mysql-server python3-pip python3-venv -y 
apt-get install sox ffmpeg libcairo2 libcairo2-dev -y 
apt-get install python3-dev default-libmysqlclient-dev build-essential -y 

# Clone the app
cd /
git clone https://github.com/Kelvinskell/terra-tier.git
cd /terra-tier

# Populate App with environmental variables
echo "MYSQL_ROOT_PASSWORD=$PASSWORD" > .env
cd /terra-tier/application
echo "MYSQL_DB=$DB" > .env
echo "MYSQL_HOST=$HOST" >> .env
echo "MYSQL_USER=$USER" >> .env
echo "DATABASE_PASSWORD=$PASSWORD" >> .env
echo "MYSQL_ROOT_PASSWORD=$PASSWORD" >> .env
echo "SECRET_KEY=08dae760c2488d8a0dca1bfb" >> .env # FLASK EXTENSION KEY. NOT NECESSARILY A "SECRET".
echo "API_KEY=f39307bb61fb31ea2c458479762b9acc" >> .env 
# YOU TYPICALLY DON'T ADD SECRETS SUCH AS API KEYS AS PART OF SOURCE CONTROL IN PLAIN TEXT.
# THIS IS BEIGN ADDED HERE SO THAT YOU CAN EASILY REPLICATE THIS INFRASTRUCTURE WITHOUT ANY HASSLES.
# YOU CAN REPLACE IT WITH YOUR OWN MEDIASTACK API KEY.

# Install the CodeDeploy agent
apt install ruby-full wget -y
cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
./install auto

# Run Flask Application
cp /terra-tier/newsread.service /etc/systemd/system/newsread.service
systemctl daemon-reload
systemctl enable newsread
pip install -r /terra-tier/requirements.txt
systemctl start newsread

# Install CloudWatch Agent
wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

# Download CloudWatch Agent Config file
git clone  https://gist.github.com/d93be79bcbe31008decda7c3b5e25e5c.git

# Run the CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:d93be79bcbe31008decda7c3b5e25e5c/config.json
sleep 4
# For some weird reason, this command has to be repeated to ensure the agent is running
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:d93be79bcbe31008decda7c3b5e25e5c/config.json