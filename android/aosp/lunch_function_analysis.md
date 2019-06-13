
## lunch函数分析

还是找不到整个编译流程, 还真得要给soong看一遍? 

1. 流程

    通过参数, 分数字与combo, 在 lunch_menu_choices 中比对

    `check_product` 函数 `$product` 来查找本地是否已经下载

    get_build_var 通过 `build/core/config.mk` 来配置一些基本变量

    通过config.mk 里的include 逐个分析

        include $(TOPDIR)vendor/mk/build/core/mtk_target.mk
        include $(TOPDIR)vendor/mk/build/core/qcom_target.mk   

    没有下载 通过 `vendor/mk/build/tools/roomservice.py` 来下载

    如果有的话, 通过 `vendor/mk/build/tools/roomservice.py` 将$product 设置为 true

    rooservice 通过分析product_name 向Mokee/product_name 下载相应的资源

    product_config.mk 是什么时候调用的? 

        envsetup.sh -> envsetup.mk -> product_config.mk, BoardConfig.mk -> node_fns.mk, product.mk, device.mk


    定义AndroidProducts.mk

    build_build_var_cache

    fixup_common_out_dir

    set_stuff_for_environment

2. 注意点

- 这么大的一个工程, 配置文件必然是复杂的, 静下心来, 逐个分析

-
