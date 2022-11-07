## 申请TLS证书

1.首先将节点域名解析到节点服务器，并且可以ping通  

```bash
# 使用必读
# 使用前请将节点域名解析到节点，并且可以ping通
# 请将命令中的domain.com替换成节点域名
curl -fsSL https://raw.githubusercontent.com/ihnic/Script/main/sign/sign.sh | bash -s domain.com
```

2.申请完成后证书将会保存至/root/.cert/server.crt /root/.cert/server.key



## 创建定时服务

1.使用```cronetab -e ```插入下面的命令（每月1号1点02分重新刷新证书）

```bash
02 01 1 * *  bash /root/.cert/cron.sh >>/root/.cert/cron.log
```
