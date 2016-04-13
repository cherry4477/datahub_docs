---
title: 'DataHub 客户端安装方法'
published: false
---

## 在Linux环境下DataHub Client端安装方式

### 1. 使用脚本安装

支持 64 位 Debian、Ubuntu、Freebsd 操作系统。打开终端，输入：

	curl -sSL https://hub.dataos.io/install.sh | sh -s xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

其中，`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`是用户的唯一标识，每个用户不同，请在 DataHub 网页上登陆后，访问安装 client 客户端页面，即可看到个人的口令。

安装过程约持续 1 分钟，完成安装后 DataHub daemon 服务会自动启动。
安装完成后，即可直接运行 client ， 执行命令：`datahub --help` 查看可执行的命令。
https://hub.dataos.io/clientDownload.html ，查看当前用户的 token 。

如果需要手动停止和启动 DataHub daemon，请执行如下命令

停止 DataHub daemon 服务:

	sudo datahub stop

启动 DataHub daemon 服务:

	sudo datahub --daemon --token xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

### 2. 使用源码安装

在安装 GO ( GO 1.4 以上版本）语言和设置完 GOPATH 环境变量之后，安装 DataHub ：

	go get github.com/asiainfoLDP/datahub

在`%GOPATH/github.com/asiainfoLDP/datahub`内执行`go install`，编译并生成可执行程序 DataHub 。

启动 DataHub daemon 服务
	
    sudo $GOPATH/bin/datahub --daemon --token xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

停止 DataHub daemon 服务
	
    sudo $GOPATH/bin/datahub stop

### 3. 使用 docker 镜像

在安装 GO ( GO 1.4 以上版本）语言和设置完 GOPATH 环境变量之后，

	git clone https://github.com/asiainfoLDP/datahub
    cd datahub
    docker build -t datahub
    
启动 Docker 镜像：

	docker run -d -e "DAEMON_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" datahub

>>>网络策略要求：若需要向 DataHub 发布数据，需提供 ENTRYPOINT ，同时修改防火墙，使得 Docker 镜像的 35800 映射到的主机端口可以被外部访问。例如:

	docker run -d -e "DAEMON_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" -e
    "DAEMON_ENTRYPOINT=http://example.com:35800" -p 35800:35800 datahub
    
## 在Windows环境下DataHub Client端安装方式    
    
### 程序安装

支持windows64位操作系统，下载Windows版Client端，安装完成后，设置环境变量。

例如Client端下载到D:\datahub目录下，给path环境变量增加一个值为“D:\datahub”的设置。

启动DataHub服务

CMD命令窗口输入:

	start datahub --daemon --token xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
