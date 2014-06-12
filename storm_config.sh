#!/bin/bash

# Host name of the node that will act as nimbus
NIMBUS_HOST="masterVM"

# Host name of the zookeeper server(s)
# (space separated list if more than one)
ZOOKEEPER_HOSTS="masterVM"

# Storm wroking directory
STORM_DIR="/app/storm"

# Storm logs directory
STORM_LOG_DIR="/var/log/storm"

# Storm installation directory
STORM_HOME="/usr/local/storm"

# Storm user
STORM_USER="hadoop"
