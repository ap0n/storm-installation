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
sudo groupadd $STORM_USER
sudo mkdir -p $STORM_DIR
sudo useradd -s /bin/bash -g $STORM_USER $STORM_USER
#sudo chown $STORM_USER:$STORM_USER $STORM_DIR
#sudo chmod 750 $STORM_DIR
sudo chage -I -1 -E -1 -m -1 -M -1 -W -1 -E -1 $STORM_USER

# Download and extract storm 0.9.1
pushd /tmp
wget http://apache.tsl.gr/storm/apache-storm-0.9.3/apache-storm-0.9.3.tar.gz
tar zxfv apache-storm-0.9.3.tar.gz
sudo mv apache-storm-0.9.3 $STORM_HOME
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
if [ "$2" == "slave" ]
then
sudo cp slave_supervisord.conf /etc/supervisor/supervisord.conf
else
sudo cp master_supervisord.conf /etc/supervisor/supervisord.conf
fi

# Start supervisor
sudo service supervisor start
popd
