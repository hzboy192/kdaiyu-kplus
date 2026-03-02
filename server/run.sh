#!/bin/bash

source /etc/profile

cd `dirname $0`

WORK_DIR=$(pwd)
APP_NAME="kplus-api"
MAIN_CLASS="cn.kdaiy.future.FuturesApplication"
# JVM参数
JVM_OPTS="-Dapp.name=${APP_NAME} -Duser.timezone=Asia/Shanghai"

function stopJar(){
		num=`ps -ef|grep -v grep |grep ${APP_NAME}|awk '{printf $2" "}'`
		if [[ -n $num ]];then
			if [ "$2" == "-f" ] || [ "$2" == "-F" ];then
				kill -9 $num
				log "Focus stop ${APP_NAME} finish."
			else
				log "Stop ${APP_NAME} use safe mode, please wait a moment..."
				kill $num
				sleep 10
				log "Stop ${APP_NAME} finish."
			fi
		else
			warn "${APP_NAME} not running."
		fi
}

function startJar(){
		pid=`ps -ef|grep -v grep |grep ${APP_NAME}|awk '{printf $2" "}'`
		if [[ -n $pid ]];then
			warn "${APP_NAME} is running..."
			break
		fi
		nohup java ${JVM_OPTS} -cp "conf:./lib/*" $MAIN_CLASS > ./logs/app.log 2>&1 &
        	
		log "${APP_NAME} start running please wait a moment ...."
		sleep 5
		count=`ps -ef|grep -v grep |grep ${APP_NAME}|wc -l`

		if [ $count -ne 1 ] && [ -n ${APP_NAME} ];then
			error "${APP_NAME} is error!"
			exit 1
		else
			log "${APP_NAME} start success."
		fi
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
