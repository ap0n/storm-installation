#!/bin/sh

for host in snf-master snf-slave0 snf-slave1 snf-slave2 snf-slave3 snf-slave4 snf-slave5 snf-slave6 snf-slave7 snf-slave8
do
	ssh user@$host 'sudo service supervisor stop'
	ssh user@$host 'sudo service supervisor start'
	echo $host ok
done