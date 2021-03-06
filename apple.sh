if [ -z "$1" ] ;then
	echo "mysql root pass empty"
	exit
fi

if [ -z "$2" ] ;then
	echo "mysql database pass empty"
	exit
fi

sudo apt update

sudo apt upgrade -y

sudo apt install ca-certificates curl gnupg lsb-release unzip -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

mkdir ~/docker
mkdir ~/AppleVoucherManage
mkdir ~/AppleVoucherApi
mkdir ~/mysql
mkdir ~/mysql/data
mkdir ~/mysql/mysql-files
mkdir ~/portainer

sudo docker pull mysql:8.0.27
sudo docker pull phpmyadmin:latest
sudo docker pull portainer/portainer-ce:latest
sudo docker pull mcr.microsoft.com/dotnet/aspnet:6.0

curl https://raw.githubusercontent.com/ys1122live/Voucher/main/AppleVoucherManage.zip -o ~/AppleVoucherManage.zip
unzip ~/AppleVoucherManage.zip -d ~/AppleVoucherManage
chmod +x ~/AppleVoucherManage/AppleVoucherManageCore
rm ~/AppleVoucherManage.zip

curl https://raw.githubusercontent.com/ys1122live/Voucher/main/AppleVoucherApi.zip -o ~/AppleVoucherApi.zip
unzip ~/AppleVoucherApi.zip -d ~/AppleVoucherApi
chmod +x ~/AppleVoucherApi/AppleVoucherApiCore
rm ~/AppleVoucherApi.zip

mkdir ~/AppleVoucherApi/wwwroot/debs

tee ~/AppleVoucherManage/appsettings.json << EOF
{
  "Logging": {
    "LogLevel": {
      "Microsoft.AspNetCore.Mvc": "Warning",
      "Microsoft.AspNetCore.Routing": "Warning",
      "Microsoft.AspNetCore.Session": "Warning",
      "Microsoft.AspNetCore.StaticFiles": "Warning",
      "Microsoft.EntityFrameworkCore": "Warning"
    }
  },
  "ConnectionStrings": {
    "version": "8.0.27-mysql",
    "connection": "server=172.18.0.2;uid=AppleVoucherManage;pwd=$2;database=AppleVoucherManage;"
  },
  "AllowedHosts": "*"
}
EOF

tee ~/AppleVoucherApi/appsettings.json << EOF
{
  "Logging": {
    "LogLevel": {
      "Microsoft.AspNetCore.Mvc": "Warning",
      "Microsoft.AspNetCore.Routing": "Warning",
      "Microsoft.AspNetCore.Session": "Warning",
      "Microsoft.AspNetCore.StaticFiles": "Warning",
      "Microsoft.EntityFrameworkCore": "Warning"
    }
  },
  "ConnectionStrings": {
    "version": "8.0.27-mysql",
    "connection": "server=172.18.0.2;uid=AppleVoucherManage;pwd=$2;database=AppleVoucherManage;"
  },
  "AllowedHosts": "*"
}
EOF

sudo docker network create --subnet=172.18.0.0/24 network

sudo docker run --name mysql --restart always -d -p 3306:3306 --network network --ip 172.18.0.2 -e TZ="Asia/Shanghai" -e MYSQL_ROOT_PASSWORD=$1 -e MYSQL_DATABASE=AppleVoucherManage -e MYSQL_USER=AppleVoucherManage -e MYSQL_PASSWORD=$2 -v ~/mysql/data:/var/lib/mysql -v ~/mysql/mysql-files:/var/lib/mysql-files -v ~/mysql/conf.d:/etc/mysql/conf.d mysql:8.0.27
sleep 20s
curl https://raw.githubusercontent.com/ys1122live/Voucher/main/AppleVoucherManage.sql -o ~/AppleVoucherManage.sql
sudo docker exec -i mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" AppleVoucherManage' < ~/AppleVoucherManage.sql
rm ~/AppleVoucherManage.sql
sleep 10s
sudo docker stop mysql
sudo docker rm mysql

sudo docker run --name mysql --restart always -d -p 3306:3306 --network network --ip 172.18.0.2 -e TZ="Asia/Shanghai" -v ~/mysql/data:/var/lib/mysql -v ~/mysql/mysql-files:/var/lib/mysql-files -v ~/mysql/conf.d:/etc/mysql/conf.d mysql:8.0.27
sudo docker run --name AppleVoucherManage --restart always -d -p 80:80 --network network --ip 172.18.0.3 -e TZ="Asia/Shanghai" -v ~/AppleVoucherManage:/app -w /app --cgroupns host mcr.microsoft.com/dotnet/aspnet:6.0 ./AppleVoucherManageCore
sudo docker run --name AppleVoucherApi --restart always -d -p 8898:80 --network network --ip 172.18.0.4 -e TZ="Asia/Shanghai" -v ~/AppleVoucherApi:/app -w /app --cgroupns host mcr.microsoft.com/dotnet/aspnet:6.0 ./AppleVoucherApiCore
sudo docker run --name phpmyadmin --restart no -d -p 9001:80 --network network --ip 172.18.0.10 -e PMA_HOST=172.18.0.2 phpmyadmin:latest
sudo docker run --name portainer --restart no -d -p 9000:9000 --network network --ip 172.18.0.11 -v ~/portainer:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce

sleep 20s
curl 'http://127.0.0.1:9000/api/users/admin/init' -H 'Content-Type: application/json' --data-raw '{"Username":"admin","Password":"ys1122@live.cn"}'
