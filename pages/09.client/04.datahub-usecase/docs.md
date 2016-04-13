---
title: 'DataHub 应用场景举例'
published: false
taxonomy:
    category:
        - docs
---

### publish 数据

发布数据是数据提供方行为。

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

### pull 数据

pull 数据是数据需求方的行为。

需求方用户登录 http://hub.dataos.io ，查看、搜索 repository 、dataitem ，然后订购自己所需的 dataitem 。订购成功后，在 tag 详情页面，点击复制，复制 tag 全名，即可在客户端 pull 此 dataitem 下的 tag 所对应的数据。

DataHub client 操作如下：

	1）datahub dp create mydp file:///home/usr/data/itempull 

以上命令创建了一个名为 mydp 的 datapool ，类型是 file ，路径是`/home/myusr/data/itempull`, 用于存储即将 pull 的数据。
	
    2）datahub pull repotest/itemtest:tagtest mydp://mydir1 –d tagdestname.txt

pull 一个 tag 对应的数据到 mydp 中，子路径是 mydir1。
