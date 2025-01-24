#!/bin/bash
# run in jenkins ssh
# bash /var/jenkins_home/workspace/futures-web/build.sh redeploy

source /etc/profile
source ~/.bashrc

cd `dirname $0`

build_dir=$(pwd)

web_server="root@tx.cn"
web_workdir="/data/iapps/fina-web"


# jenkins veriable
#module_name=$2

function build_ui(){
    pnpm install
    pnpm build
    log "pnpm build prod finish. exit status:$?" 
}


function deploy_ui(){
    ssh $web_server "rm -rf $web_workdir/*"
    scp -r $build_dir/dist/* $web_server:$web_workdir
    run_status=$?
    if [ $run_status -ne 0 ]; then
        error "deploy web server failed"
        exit 1
    else
        log "deploy web server success."
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
			build_ui
			;;
	deploy)
			deploy_ui
			;;
	redeploy)
			build_ui
			deploy_ui
			;;
	help)
			Help
			;;
	*)
			echo " Usage: ./$0 (help|build|deploy|redeploy)"
			Help
			;;
esac