
## git 打补丁

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
