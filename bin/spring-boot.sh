#!/bin/bash

# 应用名称
APP_NAME=angular-api

# JVM配置，根据需要调整
JAVA_OPTS="-server -Xms128m -Xmx256m -Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"

# 以下代码基本不需要修改
this_dir="$( cd "$( dirname "$0"  )" && pwd )"
base_dir=`dirname "${this_dir}"`
log_dir="${base_dir}/logs"
lib_dir="${base_dir}/lib"
boot_file="angular-api-0.0.1-SNAPSHOT.jar"
log_file="${APP_NAME}.log"


if [ "$1" = "" ];
then
    echo -e "\033[0;31m 未输入操作名 \033[0m  \033[0;34m {start|stop|restart|status} \033[0m"
    exit 1
fi

function start()
{
    count=`ps -ef |grep java|grep $boot_file|grep -v grep|wc -l`
    if [ $count != 0 ];then
        echo "$APP_NAME is running"
    else
        echo "Start $APP_NAME"
        nohup java $JAVA_OPTS -Dloader.path=$lib_dir -Dlogging.file=$log_dir/$log_file -jar $base_dir/$boot_file > /dev/null 2>&1 &
    fi
}

function stop()
{
    echo "Stop $APP_NAME"
    boot_id=`ps -ef |grep java|grep $boot_file|grep -v grep|awk '{print $2}'`
    count=`ps -ef |grep java|grep $boot_file|grep -v grep|wc -l`

    if [ $count != 0 ];then
        kill $boot_id
        count=`ps -ef |grep java|grep $boot_file|grep -v grep|wc -l`

        boot_id=`ps -ef |grep java|grep $boot_file|grep -v grep|awk '{print $2}'`
        kill -9 $boot_id
    fi
}

function restart()
{
    stop
    sleep 2
    start
}

function status()
{
    count=`ps -ef |grep java|grep $boot_file|grep -v grep|wc -l`
    if [ $count != 0 ];then
        tail -f $log_dir/$log_file
    else
        echo "$APP_NAME is not running"
    fi
}

case $1 in
    start)
    start;;
    stop)
    stop;;
    restart)
    restart;;
    status)
    status;;
    *)

    echo -e "\033[0;31m Usage: \033[0m  \033[0;34m sh  $0  {start|stop|restart|status} \033[0m
\033[0;31m Example: \033[0m
      \033[0;33m sh  $0  start \033[0m"
esac
