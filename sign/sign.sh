#!/bin/sh

echo '正在安装依赖'

if cat /etc/os-release | grep "centos" > /dev/null
    then
    yum install tar wget -y > /dev/null
else
    apt update > /dev/null
    apt-get install tar wget -y > /dev/null
fi

domain=$1

cd /tmp
if uname -a | grep "aarch64" > /dev/null
	then
	wget https://github.com/go-acme/lego/releases/download/v4.9.0/lego_v4.9.0_linux_arm64.tar.gz
	tar zxvf lego_v4.9.0_linux_arm64.tar.gz
	chmod 755 *
	./lego --email="admin@$domain" --domains="$domain" --http -a run
	else
	wget https://github.com/go-acme/lego/releases/download/v4.9.0/lego_v4.9.0_linux_amd64.tar.gz
	tar zxvf lego_v4.9.0_linux_amd64.tar.gz
	chmod 755 *
	./lego --email="admin@$domain" --domains="$domain" --http -a run	
fi

if ls ./.lego/certificates | grep "$domain"
    then
    echo '证书签发成功'
    mkdir /root/.cert
    cp ./.lego/certificates/$domain.crt /root/.cert/server.crt
    cp ./.lego/certificates/$domain.key /root/.cert/server.key
    echo "#!/bin/sh
curl -fsSL https://raw.githubusercontent.com/ihnic/Script/main/sign/sign.sh | bash -s $domain
sleep 60
docker restart aurora " > /root/.cert/cron.sh
else
    echo '证书签发失败'
fi

chmod +x /root/.cert/cron.sh