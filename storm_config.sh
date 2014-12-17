#!/bin/bash

# Host name of the node that will act as nimbus
NIMBUS_HOST="snf-618466.vm.okeanos.grnet.gr"

# Host name of the zookeeper server(s)
# (space separated list if more than one)
ZOOKEEPER_HOSTS="snf-618466.vm.okeanos.grnet.gr snf-618465.vm.okeanos.grnet.gr snf-618464.vm.okeanos.grnet.gr"

# Storm wroking directory
STORM_DIR="/app/storm"

# Storm logs directory
# Logs configuration didn't work! Default: $STORM_HOME/logs
# STORM_LOG_DIR="/var/log/storm"

# Storm installation directory
STORM_HOME="/usr/local/storm"

# Storm user
STORM_USER="storm"
