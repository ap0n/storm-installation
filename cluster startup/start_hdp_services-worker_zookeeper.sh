#!/bin/sh
# Start HDFS datanode
mkdir -p /var/run/hadoop/hdfs
chown -R hdfs:hadoop /var/run/hadoop/hdfs
su -l hdfs -c "/usr/lib/hadoop/sbin/hadoop-daemon.sh --config /etc/hadoop/conf start datanode"
# Start YARN nodemanager
mkdir -p /var/run/hadoop-yarn/yarn
chown -R yarn:hadoop /var/run/hadoop-yarn/yarn
su -l yarn -c "export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec ; /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh --config /etc/hadoop/conf start nodemanager"
# Start ZooKeeper
mkdir -p /var/run/zookeeper
chown -R zookeeper:hadoop /var/run/zookeeper
su - zookeeper -c "export  ZOOCFGDIR=/etc/zookeeper/conf ; export ZOOCFG=zoo.cfg ; source /etc/zookeeper/conf/zookeeper-env.sh ; /usr/lib/zookeeper/bin/zkServer.sh start"
# Start HBase regionserver
mkdir -p /var/run/hbase
chown -R hbase:hadoop /var/run/hbase
su -l hbase -c "/usr/lib/hbase/bin/hbase-daemon.sh --config /etc/hbase/conf start regionserver"
