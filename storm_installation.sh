#!/bin/bash

# Prerequisites: python2.6-2.7
#                /usr/local/lib must be in the library path

# Arguments: 1. (required) storm_config.sh
#            2. (optional) 'slave' (If exists, installs Storm as slave)

# Usage: storm_installation.sh <storm_config.sh file> <slave>

# source Storm variables
source $1

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR

# Install & stop supervisor
sudo apt-get install supervisor -y
sudo service supervisor stop

# Create user (Hasn't been used/tested yet)
# sudo groupadd -g 53001 storm
# sudo mkdir -p /app/home
# sudo useradd -u 53001 -g 53001 -d /app/home/storm -s /bin/bash storm -c "Storm service account"
# sudo chmod 700 /app/home/storm
# sudo chage -I -1 -E -1 -m -1 -M -1 -W -1 -E -1 storm

# Download and extract storm 0.9.1
pushd /tmp
wget http://apache.cc.uoc.gr/incubator/storm/apache-storm-0.9.1-incubating/apache-storm-0.9.1-incubating.tar.gz
tar zxfv apache-storm-0.9.1-incubating.tar.gz
sudo mv apache-storm-0.9.1-incubating $STORM_HOME
sudo chown -R $STORM_USER:$STORM_USER $STORM_HOME
popd

# Create working directory
sudo mkdir -p $STORM_DIR
sudo chown $STORM_USER:$STORM_USER $STORM_DIR
sudo chmod 750 $STORM_DIR

# Configure storm
TMP=""
for i in $ZOOKEEPER_HOSTS
do
TMP="$TMP - $i\n"
done
rm storm.yaml
sed -e 's/ZOOKEEPER_SERVERS/'"$TMP"'/' storm.yaml.tmpl | sed 's/NIMBUS_HOST/\"'"$NIMBUS_HOST"'\"/' | sed 's#STORM_DIR#\"'"$STORM_DIR"'\"#' > storm.yaml
sudo cp storm.yaml $STORM_HOME/conf/

# Configure supervisord
if [ $2 = "slave" ]
then
sudo cp slave_supervisord.conf /etc/supervisor/supervisord.conf
else
sudo cp master_supervisord.conf /etc/supervisor/supervisord.conf
fi

# Start supervisor
sudo service supervisor start
popd
