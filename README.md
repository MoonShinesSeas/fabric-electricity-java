> 本项目使用 Hyperledger Fabric v2.2.0 构建底层区块链网络, go 编写智能合约，应用层使用spring-boot+fabric-gateway-java+fabric-sdk-java
>
> 借鉴了多位大神的项目
>
> 跟着devx大神的视频做的架构【hyperledger-fabric【1】运行测试网络】https://www.bilibili.com/video/BV1ZR4y1M7yH?vd_source=338ae765a094660c2385a9f730cab8fd
>
> 根据GitHub上的项目进行的修改：https://github.com/togettoyou/fabric-realty

## 手动部署

环境要求： 安装了 Docker 和 Docker Compose 的 Linux 或 Mac OS 环境

> Docker 和 Docker Compose 需要先自行学习。本项目的区块链网络搭建、链码部署、前后端编译/部署都是使用 Docker 和 Docker
> Compose 完成的。

1. 下载本项目放在任意目录下，例：`/root/fabric-java
2. 给予项目权限，执行 `sudo chmod -R +x /root/fabric-java/`
3. 进入 `network` 目录，执行 `./start-go.sh` 部署区块链网络和智能合约(-go是代表链码语言为go)，启动前需要修改network目录下configtx.yaml和crypto-config.yaml文件中的ip地址，以及自己想要的端口号，docker-compose-go.yaml中的ip地址也需要修改，因为其中的ip地址每台电脑不相同。

tips：

区块链网络配置了CA用以注册用户，配置CA数据库为mysql，mysql数据库需要注意打开tls连接，Ubuntu系统中的mysql打开tls连接的步骤。

①登录mysql： mysql -uroot -pmima

②输入命令：

1）use mysql;

2）update user set host = '%' where user = 'root'; 

3)  FLUSH PRIVILEGES;

并且修改/etc/mysql/mysql.conf.d/mysqld.cnf

在文件最后加入

ssl-ca=ca.pem

ssl-cert=server-cert.pem

ssl-key=server-key.pem

<img src="D:\github\fabric-java\image\屏幕截图 2024-02-22 232550.png" alt="屏幕截图 2024-02-22 232550" style="zoom:75%;" />

③完成第二步后连接仍报错，Error occurred initializing database: Failed to create MySQL tables: Error creating certificates table: Error 1067: Invalid default value for 'expiry'。

在[mysqld]下加入sql-mode=NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION

<img src="D:\github\fabric-java\image\屏幕截图 2024-02-22 232445.png" alt="屏幕截图 2024-02-22 232445" style="zoom:75%;" />

成功启动ca

<img src="D:\github\fabric-java\image\屏幕截图 2024-02-22 233157.png" alt="屏幕截图 2024-02-22 233157" style="zoom:75%;" />

windows的步骤请自行搜索。

## 目录结构

- `application`: spring-boot项目,查询区块链网络,我并未对项目进行打包，可以在vscode或idea中配置maven运行。


- `chaincode-go` : go 编写的链码（即智能合约）


- `network` : Hyperledger Fabric 区块链网络配置

## 功能流程

用户自己创建商品。

用户查看名下商品信息。

用户发起销售，所有人可以查看销售列表，购买者购买后扣款，在卖家交付后，交易完成，更新商品所有者，在有效期内可以取消交易，有效期到后自动关闭交易。

具有溯源功能，通过商品id可以进行溯源。

## 演示效果

createElectricity:

<img src="D:\github\fabric-java\image\屏幕截图 2024-02-22 233343.png" alt="屏幕截图 2024-02-22 233343" style="zoom:75%;" />

queryElectricity:

<img src="D:\github\fabric-java\image\屏幕截图 2024-02-22 233444.png" alt="屏幕截图 2024-02-22 233444" style="zoom:75%;" />

createSelling:

<img src="D:\github\fabric-java\image\屏幕截图 2024-02-22 233827.png" alt="屏幕截图 2024-02-22 233827" style="zoom:75%;" />

buy:

<img src="D:\github\fabric-java\image\屏幕截图 2024-02-22 234104.png" alt="屏幕截图 2024-02-22 234104" style="zoom:75%;" />

updateSelling:

<img src="D:\github\fabric-java\image\屏幕截图 2024-02-22 234206.png" alt="屏幕截图 2024-02-22 234206" style="zoom:75%;" />

queryHistory:

<img src="D:\github\fabric-java\image\屏幕截图 2024-02-22 234242.png" alt="屏幕截图 2024-02-22 234242" style="zoom:75%;" />

# 最后的话

我并没有任何实战开发区块链的经验，我也在慢慢摸索，希望这个项目能给你一点启发。在最开始接触fabric时，会被繁琐的命令以及环境配置而劝退，但是慢慢的学习，也能掌握一些方法技巧，知道如何修改配置以解决报错，后续如果有时间我会继续更新这个项目，因为我还没有配置连接池，没有了解并实现其中的加密操作，加油吧。

# 谢谢支持

你的支持是我做下去的动力，如果这对你的项目或者思路有所帮助，请关照一下我的生活。

| <img src="D:\github\fabric-java\image\QQ图片20240223001030.jpg" alt="QQ图片20240223001030" style="zoom:25%;" /> |
| :----------------------------------------------------------: |
|                            支付宝                            |
