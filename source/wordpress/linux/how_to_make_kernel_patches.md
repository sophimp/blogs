---
title: 打补丁升级linux内核
uuid: 297
status: publish
date: 2019-10-11 17:54:00
tags: Kernel, 打补丁
categories: Linux
description: 打补丁， 是内核升级，Linux下的很多源码升级的传统。rom 移植的过程中， 点不亮手机，尝试给内核打补， 记录下打补丁的方法。
---

### diff, patch 工具

diff 是对两个集合的差运算, patch 是对两个集合的和运算,
每一行为集合中的元素, 所以空行并不影响结果

已验证, 确实会对比出来, 错位行后, 相同行, 不同内容, 相同内容, 添加内容等场景
再将patch 打包后, 内容与更新的文件保持了一致, 所以直接拿文件替换, 岂不是更快?
如果可以提供人工手动合并修改, 那么对比就很有用了. 这是替换解决不了的问题. 

```shell
// 对单文件打补丁(根据行号来判断, 如果中间有空行, 或者打到错误的文件上, 有风险)
diff orig.file updated.file > file.patch

// 将补丁应用到原有文件(感觉以上工作可以人工替换来完成)
patch orig.file -i file.patch -o updated-1.file

// 带文件名上下文打补丁
diff -c orig.file updated.txt > file.patch

// 打补丁时就不需要写原文件名了
patch -i file.patch -o updated-1.txt

// 对整个文件夹打补丁, -r 是对子目录递归, -c 是带上下文, 同上
diff -rc orig.dir update.dir > dir.patch
patch -i patch.dir -o updated.dir

// 使用递归打包文件夹问题, patch默认从当前文件夹中找, 将文件名前的路径都去掉, 使用-p 可以去除此操作
patch -p0 -i patch.dir

```

有 kernel/scripts/patch_kernel自动打包升级脚本. 

脚本里用的同样是diff与patch工具, 将此过程自动化了, 但是需要先提供 patch文件. 应该还有更高级的应用, 后续再研究下一款机型的时候, 给内核打包再研究. 


### git 打补丁

linux 内核, android 系统, 被这些项目逼迫不得不学打补丁, 因为手动去对比, 那是一件无比庞大的工作量. 
早就该学一学了, 不仅是git path, 还有 linux下的diff, patch. 

- 应用场景

不同的git tree, 能否打补丁, 是否可靠?

	随着主线的更新, 以前的补丁打进去可能会有冲突, 这个时候需要解决冲突. 

	只需要文件名与路径相同, 应该是都可以

diff, patch, 与 git format patch

	unix标准补丁 .diff 
	git format-patch 𥫣在的专用 .patch

创建 git .patch补丁
```sh
	# 某次提交之前的 n 次提交
	git format-patch <commit sha1 id > -n

	# 某次提交的patch
	git format-patch <commit sha1 id> -1

	# 某两次提交的patch
	git format-patch <commit sha1 id>..<commit sha1 id> 
```
创建 diff 
``` sh
	git diff <commit sha1 id> <commit sha1 id> > <diff file name>
```

应用补丁
``` sh
	# 检查patch/diff 是否可正常打入
	git apply --check <xxx.diff>
	git apply --check <xxx.patch>

	# 打入 patch/diff
	git apply <xxx.diff>
	git apply <xxx.patch>
	git am <xxx.patch>
```

解决冲突

```sh
	# 自动合入未冲突部分, 同时保留冲突部分, 同时生成 .rej 文件
	git apply --reject <xxx.patch>
	# 参考 .rej 文件手动解决冲突, 然后删除.rej文件, 然后标记冲突解决
	git am --resolved
	# 提交所解决的冲突
```
