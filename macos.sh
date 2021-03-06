if [ -z "$1" ] ;then
	echo "mysql root pass empty"
	exit
fi

if [ -z "$2" ] ;then
	echo "mysql database pass empty"
	exit
fi

mkdir ~/docker
mkdir ~/AppleVoucherManage
mkdir ~/AppleVoucherApi
mkdir ~/mysql
mkdir ~/mysql/data
mkdir ~/mysql/mysql-files
mkdir ~/portainer

docker pull mysql:8.0.27
docker pull phpmyadmin:latest
docker pull portainer/portainer-ce:latest

tee ~/docker/Dockerfile << EOF
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
ENTRYPOINT ["dotnet", "AppleVoucherManageCore.dll"]
EOF
docker build -t applevouchermanage -f ~/docker/Dockerfile .
rm ~/docker/Dockerfile

tee ~/docker/Dockerfile << EOF
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
ENTRYPOINT ["dotnet", "AppleVoucherApiCore.dll"]
EOF
docker build -t applevoucherapi -f ~/docker/Dockerfile .
rm ~/docker/Dockerfile

curl https://raw.githubusercontent.com/ys1122live/Voucher/main/AppleVoucherManage.zip -o ~/AppleVoucherManage.zip
unzip ~/AppleVoucherManage.zip -d ~/AppleVoucherManage
rm ~/AppleVoucherManage.zip

curl https://raw.githubusercontent.com/ys1122live/Voucher/main/AppleVoucherApi.zip -o ~/AppleVoucherApi.zip
unzip ~/AppleVoucherApi.zip -d ~/AppleVoucherApi
rm ~/AppleVoucherApi.zip
mkdir ~/AppleVoucherApi/wwwroot/debs

tee ~/AppleVoucherManage/appsettings.json << EOF
{
	"ConnectionStrings": {
		"type": "mysql",
		"version": "8.0.27-mysql",
		"connection": "server=172.18.0.2;uid=AppleVoucherManage;pwd=$2;database=AppleVoucherManage;"
	},
	"AllowedHosts": "*"
}
EOF

tee ~/AppleVoucherApi/appsettings.json << EOF
{
	"ConnectionStrings": {
		"type": "mysql",
		"version": "8.0.27-mysql",
		"connection": "server=172.18.0.2;uid=AppleVoucherManage;pwd=$2;database=AppleVoucherManage;"
	},
	"AllowedHosts": "*"
}
EOF

docker network create --subnet=172.18.0.0/24 network

docker run --name mysql --restart always -d -p 3306:3306 --network network --ip 172.18.0.2 -e TZ="Asia/Shanghai" -e MYSQL_ROOT_PASSWORD=$1 -e MYSQL_DATABASE=AppleVoucherManage -e MYSQL_USER=AppleVoucherManage -e MYSQL_PASSWORD=$2 -v ~/mysql/data:/var/lib/mysql -v ~/mysql/mysql-files:/var/lib/mysql-files -v ~/mysql/conf.d:/etc/mysql/conf.d mysql:8.0.27
sleep 20
curl https://raw.githubusercontent.com/ys1122live/Voucher/main/AppleVoucherManage.sql -o ~/AppleVoucherManage.sql
docker exec -i mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" AppleVoucherManage' < ~/AppleVoucherManage.sql
rm ~/AppleVoucherManage.sql
sleep 10
docker stop mysql
docker rm mysql

docker run --name mysql --restart always -d -p 3306:3306 --network network --ip 172.18.0.2 -e TZ="Asia/Shanghai" -v ~/mysql/data:/var/lib/mysql -v ~/mysql/mysql-files:/var/lib/mysql-files -v ~/mysql/conf.d:/etc/mysql/conf.d mysql:8.0.27
docker run --name AppleVoucherManage --restart always -d -p 80:80 --network network --ip 172.18.0.3 -e TZ="Asia/Shanghai" -v ~/AppleVoucherManage:/app --cgroupns host applevouchermanage:latest
docker run --name AppleVoucherApi --restart always -d -p 8898:80 --network network --ip 172.18.0.4 -e TZ="Asia/Shanghai" -v ~/AppleVoucherApi:/app --cgroupns host applevoucherapi:latest
docker run --name phpmyadmin --restart no -d -p 9001:80 --network network --ip 172.18.0.10 -e PMA_HOST=172.18.0.2 phpmyadmin:latest
docker run --name portainer --restart no -d -p 9000:9000 --network network --ip 172.18.0.11 -v ~/portainer:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce

sleep 20
curl 'http://127.0.0.1:9000/api/users/admin/init' -H 'Content-Type: application/json' --data-raw '{"Username":"admin","Password":"ys1122@live.cn"}'
