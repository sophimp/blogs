---
title: Hexo + github + gitpage 搭建blog
date: 2020-07-18 23:47:43
categories:
- hexo
tags: 
- 博客搭建
description: hexo + github + gitpage 搭建个人博客， 想法的记录， 思考过程的展现， 以及配置的展示。 
---

## 使用 Hexo + github + gitpage 搭建博客

搭建博客，相比如内容，技术反而是次要的。

博客放哪些内容， 采用什么样的布局，什么样的风格, 这些做到胸中了然， 搭建的过程，哪里不会搜哪里即可。 
以我的经验来看， 想要搭一个什么样的博客， 绝大多数人一开始是做不到心中有数的。 这也是很多人大多数时候无从下手的根本原因。所谓万事开头难, 不过如此。

那么如何解决万事开头难的问题呢？
迭代思想! 

### 基本需求

迭代的核心思想：开始不要想得太细致完美，满足基本需求，发布初始版本，然后逐版本迭代。 

> 先分析最根本的需求：记录思想，复盘，分享。

满足这些需求， 我只需写出blog，然后部署到公网被访问即可。

写blog, 有最基本的编辑器就可以完成。 部署到公网需要服务器，域名。

那么开始搜索`搭建博客`, 在结果里统计一些方案, 满足以上需求， 就可以按教程开始搭建博客了。

这里我选择 hexo + github + gitpage 搭建博客, 主要有以下考量:

- hexo 是当前最流行的博客管理框架，流行意味着学习资料多, 这里切莫为了彰显个性而刻意不同, 记住建博客的初衷, 花样上的个性并没有想象中的酷，内容上的深度才是彰显个性的根本。
- github 可以满足云同步， 且迭代版本跟踪。是个神器， 一个合格的程序员都知道, 不是程序员学一学也绝对是百利无一害。
- gitpage 可以解决服务器与域名的问题，虽然只有目前有1G的容量的限制， 但是写博客是绝对够用了, 当然， 有视频与图片， 最好放在专门的服务器使用网络链接。

至于hexo安装, github 使用， gitpage 开启，参考官方文档，结合其他博主写的教程，可以快速上手, 这里就不详细写了。

[hexo 官方文档](https://hexo.bootcss.com/docs/)
[hexo github 项目](https://github.com/hexojs/hexo)
[git使用手册](https://git-scm.com/book/zh/v2)
[gitpage 文档](https://pages.github.com/)


### 定制化需求

完成基本的需求, 随着写博客的过程，逐步迭代满足定制化需求。

定制化也要先解决想要什么的问题。如何布局博客, 我是先参考 [Blankj's Blog](http://blankj.github.io/) 的风格。 使用的是 [next](https://github.com/theme-next/hexo-theme-next) 主题。

Next 主题目前基本上满足了我的需求： 

侧边栏, 首页，归档， 标签，分类，分页。这些功能已经满足了文章的管理需求。 后续再添加上评论。

关于next主题的配置，网络上已经有了很多[教程](https://blog.csdn.net/u012294515/article/details/83094693)，不过大部分都与当前最新版本有些差别, 这里需要灵活对待。 

`hexo init` 的根目录下的 `_config.yml` 是全局配置，theme/next 下的 `_config.yml` 是针对主题的配置。仔细看这两个文件的注释，大部分是打开开关的操作，对比着教程中的关键词， 搜索着配置即可。 

这里有几点建议: 
1. 不要搞得太花哩胡哨的， 因为github 的在国内的访问速度毕竟还是慢一些。
2. 整体的界面保持简洁， 保持影响阅读体验的良好。所以，够用，方便阅读, 查找，更新，管理文章即可。

[个人的next定制仓库](https://gitee.com/sophimp/hexo-theme-next)

### 博客管理

官方推荐的是博客原文与部署文件分两个仓库管理。 

```sh
hexo new page  <page name> # 是在图像下添加标签页的 如 post, categories, tags
hexo new <file name> # 默认是在 source/_post 文件夹下创建一个md 文件， 使用的是 scaffolds/_post.md 作为模板 

# 如果想要博客原文也分文件夹管理，直接在 source/_post 下创建文件夹，然后通过复制 _post.md 到指定的文件夹下来创建博客. 是可以达到原文博客的分类管理。 
```

使用 categories, tags, 时间轴，基本上就可以快速定位到blog, 满足管理需求。 当然再加上一个`搜索`功能更好。

### 技巧点

文章相对路径引用(`<> 代表必填项 [] 代表选填项`, 这是命令文档中的约定 )

```
{% post_link <文章的相对路径> [文章的章节名称] %}`
```

显示相对路径

```
{% post_path <文章的相对路径> %}
```

文章资源引用

```
{% asset_path <资源相对路径> %}
{% asset_img <图片相对路径> [图片名称]%}
{% asset_link <资源相对路径> [资源的子标题]%}
```

[设置背景图](https://blog.csdn.net/TomAndersen/article/details/104872852)


### 持续迭代

后面有想法， 再更新。