
## 如何打补丁升级linux内核

diff 工具
patch 工具

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


