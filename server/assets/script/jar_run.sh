#!/bin/bash

source /etc/profile

cd `dirname $0`

WORK_DIR=$(pwd)
# 模糊匹配程序，多个用空格隔开，eg: ls ./lib/common-*.jar ./lib/kdaiy-*.jar
JAR_LIST=$(ls ./lib/kdaiy-admin-*.jar)
# JVM参数
JVM_OPTS="-Duser.timezone=Asia/Shanghai"
# 应用参数
APP_ARGS="--spring.config.location=./conf/application.yaml"

function stopJar(){
	lt=${#JAR_LIST[*]}
	for ((i = 0;i< $lt; i++))
	do
		num=`ps -ef|grep -v grep |grep ${JAR_LIST[$i]}|awk '{printf $2" "}'`
		if [[ -n $num ]];then
			if [ "$2" == "-f" ] || [ "$2" == "-F" ];then
				kill -9 $num
				log "Focus stop ${JAR_LIST[$i]} finish."
			else
				log "Stop ${JAR_LIST[$i]} use safe mode, please wait a moment..."
				kill $num
				sleep 10
				log "Stop ${JAR_LIST[$i]} finish."
			fi
		else
			warn "${JAR_LIST[$i]} not running."
		fi
	done
}

function startJar(){
	lt=${#JAR_LIST[*]}
	for ((i = 0; i < $lt; i++))
	do
		pid=`ps -ef|grep -v grep |grep ${JAR_LIST[$i]}|awk '{printf $2" "}'`
		if [[ -n $pid ]];then
			warn "${JAR_LIST[$i]} is running..."
			break
		fi
		nohup java ${JVM_OPTS} -jar ${JAR_LIST[$i]} ${APP_ARGS} > ./logs/app.log 2>&1 &
        	
		log "${JAR_LIST[$i]} start running please wait a moment ...."
		sleep 5
		count=`ps -ef|grep -v grep |grep ${JAR_LIST[$i]}|wc -l`

		if [ $count -ne 1 ] && [ -n ${JAR_LIST[$i]} ];then
			error "${JAR_LIST[$i]} is error!"
			exit 1
		else
			log "${JAR_LIST[$i]} start success."
		fi

	done
}

function Help()
{
        echo "用法：$0 [选项]"
        echo "选项："
        echo "  start                                    启动jar"
        echo "  stop                                     停止jar, -f 强制退出"
        echo "  restart                                  重启jar"
        echo "  help                                     帮助"
}

function log() {
	echo "[INFO] =>> $(date "+%Y-%m-%d %H:%M:%S") $1 "
}

function warn() {
        echo "[WARN] =>> $(date "+%Y-%m-%d %H:%M:%S") $1 "
}

function error() {
        echo "[ERROR] =>> $(date "+%Y-%m-%d %H:%M:%S") $1 "
}

case $1 in
	start)
			startJar
			;;
	stop)
			stopJar $*
			;;
	restart)
			stopJar
			sleep 3
			startJar
			;;
	help)
			Help
			;;
	*)
			echo " Usage: ./$0 (help|start|stop|restart)"
			Help
			;;
esac
