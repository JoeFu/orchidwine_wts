# mysql.sh
# 每小时压缩，并检查之前的文件有无压缩遗漏
# 清理一天以前的原文件
# 清理三天前的压缩文件
# 远程每小时同步
cd /home/orchid/backup/mysql/
if [ ! -x tar ]; then
	mkdir tar
fi

lasted=`expr $(date +%s)`
lasted=$(date -d @$lasted +%Y%m%d%H%M)

mysqldump -uroot -pR8o3H9Y79gX2c46C orchid_wine > mysql-$lasted-orchid_wine.sql

# 每小时压缩，并检查之前的文件有无压缩遗漏
for file in ./mysql*
do
	tarname=$file-tar.gz
	if [ ! -f tar/$tarname ]; then
		echo "tar $tarname $file"
		tar zcf $tarname $file
		echo "mv $tarname tar/"
		mv $tarname tar/
	fi

	# 清理一天以前的原文件
	updated=`echo $file |awk -F "-" '{print $2}'`
	# echo "file:$file == updated: $updated -le lasted: $lasted"
	if [ $updated -le $lasted ];then
		echo "rm $file"
		rm $file
	fi
done

# 清理30天前的压缩文件
cd tar
lasted=`expr $(date +%s) - 60 \* 60 \* 24 \* 15`
lasted=$(date -d @$lasted +%Y%m%d%H%M)

for file in ./*
do
	updated=`echo $file |awk -F "-" '{print $2}'`
#	echo "file:$file == updated: $updated -le lasted: $lasted"
	if [ $updated -le $lasted ];then
#		echo "rm $file"
		rm $file
	fi
done
