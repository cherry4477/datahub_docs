---
title: 'DataHub 客户端命令介绍'
taxonomy:
    category:
        - docs
---

DataHub Client 是 DataHub 的命令行客户端，用来执行 DataHub 相关命令。

| 命令	    | 用途              |
| :---------- | :----------       |
| dp          | Datapool 管理      |
| subs        | Subscrption 管理   |
| login       | 登录到 dataos.io   | 
| pull        | 下载数据           |
| pub         | 发布数据           |
| repo        | Repository 管理   |
| job         | 显示任务列表       |
| help        | 帮助命令          |  


## Datahub Client命令行使用说明

#### NOTE：
- 如果没有额外说明，所有的命令在没有错误发生时，不在终端输出任何信息，只记录到日志中。错误信息会打印到终端。
- 所有的命令执行都会记录到日志中，日志级别分[TRACE] [INFO] [WARNNING] [ERROR] [FATAL]。
- 参数支持全名和简称两种形式，例如--type等同于-t。详情见命令帮助。
- 参数赋值支持空格和等号两种形式，例如--type=file等同于--type file。


### 1. datapool 相关命令

#### 1.1 列出所有命令池

	datahub dp
    
输出
	
    {%DPNAME    %DPTYPE}

例子

    $ datahub dp
    DATAPOOL            TYPE    
	------------------------
	dp1                 file 
	dp2                 db2
	dphere              hdfs
	dpthere             api
	$
    
#### 1.2 列出 datapool 详情

	datahub dp $DPNAME

输出

    %DPNAME 			%DPTYPE 		%DPCONN
    {%REPO/%ITEM:%TAG	%LOCAL_TIME		%T}

例子

    $  datahub dp dp1
    DATAPOOL:dp1            file                      /var/lib/datahub/dp1
    repo1/item1:tag1        2015-10-23 03:57:42       pub
    repo1/item1:tag2        2015-10-23 03:59:49       pub
    repo1/item2:latest      2015-10-23 04:01:22       pull
	cmcc/beijing:latest     2015-11-19 10:57:21       pull
    $ 
    
#### 1.3 创建数据池
- 目前只支持本地目录形式的数据池创建。

		datahub dp create $DPNAME [[file://][ABSOLUTE PATH]] | [[s3://][BUCKET]] | [[hdfs://][USERNAME:PASSWORD@HOST:PORT]]

输出

	%msg

例子1

    $ datahub dp create testdp file:///var/lib/datahub/testdp
   	DataHub : Datapool has been created successfully. Name:testdp Type:file Path:/var/lib/datahub/testdp.
    $
    
例子 2

	$ datahub dp create s3dp s3://mybucket
	DataHub : s3dp already exists, please change another name.
	$

    
#### 1.4 删除数据池
- 删除数据池不会删除目标数据池已保存的数据。该dp有发布的数据项时，不能被删除。删除是在sqlite中标记状态，不真实删除。

		datahub dp rm $DPNAME

输出

	%msg

例子

    $ datahub dp rm testdp
	DataHub : Datapool testdp removed successfully!
    $

### 2. subs 相关命令
#### 2.1 列出所有已订阅项

	datahub subs 

输出

	REPOSITORY/ITEM     TYPE    STATUS
	{%REPO/%ITEM        %TYPE   online/offline}

例子

	$ datahub subs
	REPOSITORY/ITEM     TYPE    STATUS
	cmcc/beijing        file    online
	repo1/testing       hdfs    online
    $
  
#### 2.2 列出用户在某个repository下已订阅的item

	datahub subs $REPO

	输出

	%REPO/%ITEM     %TYPE
	{%ITEM:%TAGNAME %UPDATE_TIME    %INFO}

	例子

		$ datahub subs cmcc
			cmcc/beijing    regular file
		$ datahub subs cmcc
			cmcc/Beijing     file
			cmcc/Tianjin     file
			cmcc/Shanghai    file
		$

    
#### 2.3 列出已订阅 item 详情

	datahub subs $REPO/$ITEM

输出

    %REPO/%ITEM     %TYPE
    {%ITEM:%TAGNAME %UPDATE_TIME    %INFO}
    
例子

    $ datahub subs cmcc/beijing
    beijing:chaoyang    15:34 Oct 12 2015       600M
    beijing:daxing  16:40 Oct 13 2015       435M
    beijing:shunyi  16:40 Oct 14 2015       324M
    beijing:haidian 16:40 Oct 15 2015       988M
    $
    
### 3. pull 命令
#### 3.1 拉取某个 item 的 tag。

- pull 一个 tag ，需指定`$DATAPOOL`, 可再指定`$DATAPOOL`下的子目录`$LOCATION`，默认下载到`$DATAPOOL://$REPO_$ITEM`。 可选参数`[--destname, -d]`命名下载的 tag [--automatic, -a]自动下载已订阅的Item新增的tag [--cancel, -c]取消自动下载tag 。

		datahub pull $REPO/$ITEM:$TAG $DATAPOOL[://$LOCATION] [--destname，-d]

输出

	%msg

例子

	$ datahub pull cmcc/beijing:chaoyang dp1://cmccbj
    	DataHub : OK.
        $

### 4. login 命令

- login 命令支持被动调用，用于 DataHub client 与 DataHub server 交互时作认证。并将认证信息保存到环境变量，免去后续指令重复输入认证信息。

#### 4.1 登陆到 dataos.io

	datahub login [--user=user]

输出

	%msg
    
例子

    $ datahub login
	login as: datahub
	password: *******
	Error : login failed.
    $

    
### 5. pub 相关命令

- pub 分为发布一个 DataItem 和发布一个 Tag 。

- 发布 DataItem 必须指定 DATAPOOL 和 DATAPOOL 下的子路径 LOCATION , 可选参数`--accesstype`, `-t=` 指定DataItem属性：public, private, 默认private 。

- 发布 Tag 必须指定 TAGDETAIL , 用来指定 Tag 对应文件名，该文件必须存在于`$DATAPOOL://$LOCATION`内。

- 可选参数`--comment`, `-m=` ,描述 DataItem 或者 Tag 。

#### 5.1 发布一个 item

	datahub pub $REPOSITORY/$DATAITEM $DATAPOOL://$LOCATION --accesstype=public [private]  [--comment, -m]

输出

	Pub success,  OK

例子

    $./datahub pub music_1/migu mydp://dirmigu --accesstype=public --comment="migu music desc"
    DataHub : Pub success,  OK

#### 5.2 发布一个 tag

	datahub pub $REPO/$ITEM:$Tag $TAGDETAIL --comment=" "

输出

	Pub success, OK

例子

    $ datahub pub music_1/migu:migu_user_info migu_user_info.txt
    DataHub : Pub success, OK
    $

### 6. repo 命令

#### 6.1 查询自己创建的和具有写权限的所有 repository

	datahub repo 

输出

    REPOSITORY
    --------------------
    Location_information                    
    Internet_stats  
    Base_station_location

#### 6.2 查询repository的详情

	datahub repo Internet_stats

输出

    REPOSITORY/DATAITEM
    --------------------------------
    Internet_stats/Music
    Internet_stats/Books
    Internet_stats/Cars
    Internet_stats/Ecommerce_goods
	Internet_stats/Film_and_television

#### 6.3 查询dataitem的详情

	datahub repo  Internet_stats/Music

输出

	REPOSITORY/ITEM:TAG 						UPDATETIME  				 COMMENT
    -------------------------------------------------------------------------------------
    Internet_stats/Music:music_baidumusic_6008  2016-03-04 09:15:18|6天前 	百度音乐
    Internet_stats/Music:music_qqmusic_6001     2016-02-03 09:23:30|1个月前  	QQ音乐
	Internet_stats/Music:music_kuwomusic_6005   2016-01-06 09:35:44|2个月前  	酷我音乐


#### 6.4 删除自己创建的dataitem

	datahub repo rm myrepo/myitem

输出

    Datahub : After you delete the DataItem, data could not be recovery, and all tags would be deleted either.
    Are you sure to delete the current DataItem?[Y or N]:Y
	DataHub : OK

说明：当此dataitem下有正在生效的订购计划时，会提示资费回退规则。

#### 6.5 删除自己创建的tag

	datahub repo rm FavouriteMusic/MusicItem:bingyu

输出

	DataHub : After you delete the Tag, data could not be recovery.
	Are you sure to delete the current Tag?[Y or N]:y
	DataHub : OK
    
### 7. job 命令
#### 7.1 job 查看所有任务列表，包括数据下载和发送的任务

	datahub job

#### 7.2 job 查看某个任务 id 对应的信息
	
    datahub job &JOBID

#### 7.3 job rm 删除某个 job
	
    datahub job rm &JOBID

### 8. help 命令

- help 提供 DataHub 所有命令的帮助信息。

#### 8.1 列出帮助

	datahub help [$CMD] [$SUBCMD]

输出

    Usage of %CMD %SUBCMD
    {  %OPTION=%DEFAULT_VALUE     %OPTION_DESCRIPTION}

例子

    $datahub help dp
    Usage: 
      datahub dp [DATAPOOL]
    List all the datapools or one datapool

    Usage of datahub dp create:
      datahub dp create DATAPOOL [file://][ABSOLUTE PATH]
      e.g. datahub dp create dptest file:///home/user/test
           datahub dp create dptest /home/user/test
    Create a datapool

    Usage of datahub dp rm:
      datahub dp rm DATAPOOL
    Remove a datapool
    $



## DataHub 应用场景举例

### 1. publish 数据

- 发布数据是数据提供方行为。

在 DataHub 产品中，数据组织划分为 repository 、dataitem 、tag ，其中 repository 是数据仓库， dataitem 是一个数据项，包含一个主题的数据， tag 是一个具体的数据记录。

提供方发布数据前要在本地基于已有数据建立一个 datapool，发布这个 datapool 里面的数据。

假设在`/home/myusr/data/topub`目录下存在若干文件，现在想把这些文件发布为一些 tags ，等待需求方来下载。
操作过程如下：

	1) datahub dp create mydatapool file:///home/myusr/data

以上命令创建了一个datapool，类型是file，路径是`/home/myusr/data`。

	2) datahub pub myrepo/myitem mydatapool://topub --accesstype=public --comment="my test item "

发布一个名称为 myitem 的 dataitem ，所属 repository 是 myrepo ，对应 mydatapool 的子目录 topub ，即待发布数据存在于`/home/myusr/data/topub`中。

>>>>注意：在发布 dataitem 之前，可以在其对应的目录里创建、编译三个文件：sample.md, meta.md, price.cfg。

这三个文件的作用分别是：
* sample.md 用于保存 markdown 格式的样例数据，如果没有此文件，程序会读取此目录下的一个 tag 文件的前十行，作为样例数据，发布到 dataitem 的详情里。
* meta.md 用于保存 markdown 格式的元数据。
* price.cfg 用于保存 json 格式的资费计划，用来明确此 dataitem 的资费。格式如下：

```markdown
{
"price":[
                {
                    "times":10,
                    "money": 5,
                    "expire":30
                },
                {
                    "times": 100,
                    "money": 45,
                    "expire":30
                },
                {
                    "times":500,
                    "money": 400,
                    "expire":30
                }
        ]
}
```

	3) datahub pub myrepo/myitem:mytag test.txt

发布一名称为 mytag 的 tag ，所属 dataitem 是 myitem ，对应数据文件是 `/home/myusr/data/topub/test.txt`。

### 2. pull 数据

- pull 数据是数据需求方的行为。

需求方用户登录 http://hub.dataos.io ，查看、搜索 repository 、dataitem ，然后订购自己所需的 dataitem 。订购成功后，在 tag 详情页面，点击复制，复制 tag 全名，即可在客户端 pull 此 dataitem 下的 tag 所对应的数据。

DataHub Client 操作如下：

	1）datahub dp create mydp file:///home/usr/data/itempull 

以上命令创建了一个名为 mydp 的 datapool ，类型是 file ，路径是`/home/myusr/data/itempull`, 用于存储即将 pull 的数据。
	
    2）datahub pull repotest/itemtest:tagtest mydp://mydir1 –d tagdestname.txt

pull 一个 tag 对应的数据到 mydp 中，子路径是 mydir1。
