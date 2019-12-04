
## 概念

整个 portage 用python写的

ebuild 

repository 

portage

## 如何滚动更新

```sh
# 更新软件仓库
emerge --sync # 调用 rsync 增量更新

emerge-webrsync # 使用web请求方式更新， 针对防火墙阻止了rsync更新的方式

# 更新 portage树
emerge --update --deep --with-bdeps=y --newuse --ask @world

```

## 安装软件

1. 正常安装

2. mask

3. unmask

4. 安装稳定版本

5. 安装 binary 版本

6. 日志查看

7. 进程查看


8. 网络查看

9. 

