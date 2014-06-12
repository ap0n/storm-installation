#!/bin/bash
source $1
# Prerequisites: python2.6-2.7
# 				 /usr/local/lib must be in the library path

# Arguments: 1. (required) storm_config.sh
#			 2. (optional) 'slave' if exists, runs to slave machine.

# Install prerequisites
sudo apt-get install automake autoconf libtool build-essential -y

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR

# Add ZeroMQ ppa
sudo add-apt-repository ppa:chris-lea/zeromq -y
sudo apt-get update
sudo apt-get install libzmq3 libzmq3-dev libzmq3-dbg -y

# Make JZMQ
git clone git://github.com/zeromq/jzmq.git
pushd jzmq/
./autogen.sh
./configure --prefix=/usr/local
make
sudo make install
popd

# Install & stop supervisor
sudo apt-get install supervisor -y
sudo service supervisor stop

# Create user

# sudo groupadd -g 53001 storm
# sudo mkdir -p /app/home
# sudo useradd -u 53001 -g 53001 -d /app/home/storm -s /bin/bash storm -c "Storm service account"
# sudo chmod 700 /app/home/storm
# sudo chage -I -1 -E -1 -m -1 -M -1 -W -1 -E -1 storm

# Download and extract storm 0.9.1

wget http://apache.cc.uoc.gr/incubator/storm/apache-storm-0.9.1-incubating/apache-storm-0.9.1-incubating.tar.gz
mv apache-storm-0.9.1-incubating.tar.gz /tmp
pushd /tmp
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
sudo cp storm.yaml /usr/local/storm/conf

# Configure supervisord
#sudo mkdir -p $STORM_LOG_DIR
if [ "$#" -lt 3 ]
then
#sed -e 's#LOG_DIR#'"$STORM_LOG_DIR"'#' master_supervisord.conf.tmpl > master_supervisord.conf
sudo cp master_supervisord.conf /etc/supervisor/supervisord.conf
else
#sed -e 's#LOG_DIR#'"$STORM_LOG_DIR"'#' slave_supervisord.conf.tmpl > slave_supervisord.conf
sudo cp slave_supervisord.conf /etc/supervisor/supervisord.conf
fi

# Start supervisor
sudo service supervisor start
popd
