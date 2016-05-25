#!/bin/bash

#BEGIN INIT INFO
# Short-Description:  Start redis and thin web services
# Description:        This script start/restart the services Redis-server and Thin-server whenever they are down
# Version:            1.0.0
### END INIT INFO

pid=0;

while true 
do 

  pid_thin=` ps auxw | grep 'thin server'  | grep -v grep | awk '{print $2}'`
  pid_redis=`ps auxw | grep 'redis-server' | grep -v grep | awk '{print $2}'`  

  if [ -z "$pid_thin" ]; then
    
    if [ -n "$pid_redis" ]; then
     kill -9 $pid_redis
    fi

    echo 'Iniciando redis-server...'
    redis-server --daemonize yes
    pid_redis=`ps auxw | grep 'redis-server' | grep -v grep | awk '{print $2}'`
    sleep 5

    echo 'Iniciando thin server..'
    thin -C config/thin.yml start 
    sleep 5
    continue
  fi

  if [ $pid -ne $pid_thin ]; then
    pid=$pid_thin
    echo '--------------------------------------------'	
    echo '| Process             | ID                 |'
    echo '+---------------------+--------------------+'
    echo "| redis-server        | $pid_redis              |"
    echo "| thin-server         | $pid_thin              |"
    echo '+------------------------------------------+'
  fi

  sleep 5
  continue
done