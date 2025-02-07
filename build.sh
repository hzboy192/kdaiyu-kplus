#!/bin/bash
# run in jenkins ssh
# bash /var/jenkins_home/workspace/futures-web/build.sh redeploy

source /etc/profile
source ~/.bashrc

cd `dirname $0`

build_dir=$(pwd)

web_server="root@tx.cn"
web_workdir="/data/iapps"


# jenkins veriable
module_name=$2

function build(){
    if [ "$module_name" == "kplus-admin" ]; then
      pnpm admin:build
    elif [ "$module_name" == "kplus-web" ]; then
      pnpm web:build
    elif [ "$module_name" == "ALL" ]; then
      pnpm all:build
    else 
      error "module name not in ALL|kplus-admin|kplus-web"
      exit 1
    fi
    log "pnpm build prod finish. exit status:$?" 
}

function deploy(){
    if [ "$module_name" == "kplus-admin" -o "$module_name" == "kplus-web" ]; then
      deploy_module $module_name
    elif [ "$module_name" == "ALL" ]; then
      deploy_module "kplus-admin"
      deploy_module "kplus-web"
    else 
      error "module name not in ALL|kplus-admin|kplus-web"
      exit 1
    fi
}

function deploy_moudule(){
    local cur_module=$1
    ssh $web_server "rm -rf $web_workdir/$cur_module/*"
    scp -r $build_dir/packages/$cur_module/dist/* $web_server:$web_workdir/$cur_module/
    run_status=$?
    if [ $run_status -ne 0 ]; then
        error "deploy web $cur_module failed"
        exit 1
    else
        log "deploy web $cur_module success."
    fi
}

function log() {
	echo "[INFO] =>> $(date "+%Y-%m-%d %H:%M:%S") $1"
}

function warn() {
        echo "[WARN] =>> $(date "+%Y-%m-%d %H:%M:%S") $1 "
}

function error() {
        echo "[ERROR] =>> $(date "+%Y-%m-%d %H:%M:%S") $1 "
}

function Help()
{
        echo "用法：$0 [选项]"
        echo "选项："
        echo "  build                                    构建jar"
        echo "  deploy                                   部署到服务器"
        echo "  redeploy                                 重新部署[build+deploy]"
        echo "  help                                     帮助"
}

case $1 in
	build)
			build
			;;
	deploy)
			deploy
			;;
	redeploy)
			build
			deploy
			;;
	help)
			Help
			;;
	*)
			echo " Usage: ./$0 (help|build|deploy|redeploy)"
			Help
			;;
esac