
## repo gerrit 的使用

gerrit 项目管理工具, 方便于代码review, merge

repo 多git项目管理工具

这两个工具也是开发的利器. 工具真得很有用, 比手工管理方便太多

### repo

repo 是一个多git项目管理工具, 所以, 理论上不同repo版本所维护的版本, 都可以使用最新版本的repo. 
repo里的差别是 默认的 REPO_URL, MAINTAINER_KEY

如何去同步一个项目? 还是要去和项目的官网或论坛上去找.
比如 codeaurora 的代码, 在[浏览器](https://source.codeaurora.org)上看是一回事
但是整体的项目 clone 下来, 还要是从[codeaurora wiki上去找](https://wiki.codeaurora.org/xwiki/bin/QAEP/)

[aosp](https://source.android.com) 
[mokee](https://mokeedev.review) 
[lineage](https://review.lineageos.org) 

repo 的使用方法 可以通过 repo help 来学习, 常用的记录如下:

```sh
	# 初始化,同步
	repo init -u <src_url> -b <branch_name> [-m <manifest_name>]
	repo sync [--force-sync]

	# 创建各个库的tag
	repo forall -c git tag <tag_name>
	repo forall -c git push origin --tags
	# 下载tag 代码
	repo init -u <src_url>  -b refs/tags/<tag_name>
	repo sync
	# 从清单中指定的修订版开始,创建一个新的分支进行开发
	repo start <tag_name>
	
```

### git 打补丁

	两个git 仓库的不同之处
	如何打补丁
	
