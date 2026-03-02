#!/bin/bash
#
# 数据库备份脚本，通过定时任务执行

source /etc/profile

export PGPASSWORD=rYJZqEYevGz4QvW490AtJiIu

gdb_server="-h cainan.cn -U APP_STK_READ_WRITE -d postgres -p 6543"
backup_dir_local=/var/jenkins_home/workspace/CRON-DB-FINA-BACKUP
backup_dir_remote=/data/server_backup/database/stk_pg
remote_server=root@tx.cn
file_name_suffix=$(date "+%Y%m")

# 只导出表结构, 如果用自定义格式导出到一个文件也可以，pg_restore可以选择恢复结构还是数据，还可以恢复指定的表
function backup_schema_only() {
    # 导出框架表
    mkdir -p $backup_dir_local/$file_name_suffix
    pg_dump $gdb_server -t stk.* -s -v -f $backup_dir_local/$file_name_suffix/cainan_pg_stk_ddl.sql
    log "导出stk.*表完成.结束状态:$?"
}

# 导出机构及数据,采用自定义格式dump所有
function backup_struct_with_data() {
    mkdir -p $backup_dir_local/$file_name_suffix
    # 导出框架数据
    pg_dump $gdb_server -t stk.* -v -F c -f $backup_dir_local/$file_name_suffix/cainan_pg_stk_data.dump
    log "dump所有结构及数据完成.结束状态:$?"
    
}

# 同步到远端服务器备份
function rsync_remote_server() {
    scp -r $backup_dir_local/$file_name_suffix $remote_server:$backup_dir_remote/
    log "同步到远端服务器备份.结束状态:$?"
}

# 备份数据库
function backup() {
  if [ "$1" == "ALL" ]; then
      backup_schema_only
      backup_struct_with_data
      rsync_remote_server
  elif [ "$1" == "DDL" ]; then
      backup_schema_only
  elif [ "$1" == "DATA" ]; then
      backup_struct_with_data
  else
      error "参数错误! 支持ALL|DDL|DATA"
      exit 1
  fi
  
}

# 还原数据库，根据需要选择性恢复
function restore() {
  # 恢复数据库结构
  # psql -h cainan.cn -U root -d postgres -f ./cainan_pg_stk_ddl.sql
  
  # 恢复dump文件中的所有内容
  # pg_restore -h cainan.cn -U root -d postgres -v ./fina_backup_all.dump
  # 恢复指定的表结构和数据
  # pg_restore -h cainan.cn -U root -d postgres -t sys_config -v ./cainan_pg_stk_data.dump
  # 只恢复指定表的结构
  # pg_restore -h cainan.cn -U root -d postgres -t sys_config -s -v ./cainan_pg_stk_data.dump
  # 只恢复指定表的数据
  # pg_restore -h cainan.cn -U root -d postgres -t sys_config -a -v ./cainan_pg_stk_data.dump
  
  log "恢复数据库完成.结束状态:$?"
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
        echo "  backup                                   备份数据库ALL|DDL|DATA"
        echo "  restore                                  回复数据库ALL|DDL|DATA"
        echo "  help                                     帮助"
}

case $1 in
	backup)
			backup $2
			;;
	restore)
			restore $2
			;;
	help)
			Help
			;;
	*)
			echo " Usage: ./$0 (backup|restore)"
			Help
			;;
esac