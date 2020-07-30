
# 先部署当前分支的
hexo d

# 再布署另一分支的
if [ $(ls |grep "_config.yml.github") ]
then
	echo $(ls | grep "_config.yml.github")
	mv _config.yml _config.yml.gitee
	mv _config.yml.github _config.yml
	hexo d
else
	echo $(ls | grep "_config.yml.gitee")
	mv _config.yml _config.yml.github
	mv _config.yml.gitee _config.yml
	hexo d
fi
