---
title: 'DataHub 客户端程序简介'
published: false
taxonomy:
    category:
        - docs
---

DataHub 程序具有两个功能：
1. client
2. daemon

DataHub client 是用于在命令行输入指令的客户端，其功能只是向 daemon 发送指令，并展示返回信息。

DataHub daemon 是常驻后台的进程，负责接收 client 的指令，并执行，即 DataHub 的实际功能都是通过 daemon 实现的。

二者启动命令相同，通过启动参数区分，启动命令都是 `datahub`， 带参数 `--daemon`，表示启动 DataHub daemon，不带参数 `--daemon`,表示启动 DataHub client。
