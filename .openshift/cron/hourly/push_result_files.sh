#!/bin/bash
# This deploy hook gets executed after dependencies are resolved and the
# build hook has been run but before the application has been started back
# up again.  This script gets executed directly, so it could be python, php,
# ruby, etc.
# 每天凌晨0-1点取一个小时前的数据文件生成tar包
log_file="$OPENSHIFT_DATA_DIR/zhidao_tar.log"
exec 2>&1 1>> $log_file &
minutes_ago=60
date_scp="$(date +%Y%m%d)12"
date=$(date +%Y%m%d%H)
dest_dir="$OPENSHIFT_DATA_DIR/zhidao"
if [ $date -eq $date_scp ];then
  echo "=========start build tar file: $date============="
  cd $dest_dir
  #拷贝文件到日期目录下
  mkdir $date
  find $dest_dir -mmin +$minutes_ago -name "*.sql" -type f | xargs -i mv {} $date 
  cd $date
  #压缩
  result_tar_filename="$date.tar.gz"
  tar -zcvf $result_tar_filename . 
  echo "=========finish build tar file: $result_tar_filename============="
fi
