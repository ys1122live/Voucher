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

sudo mkdir /home/$USER/AppleVoucherManage
sudo mkdir /home/$USER/mysql
sudo mkdir /home/$USER/mysql/data
sudo mkdir /home/$USER/mysql/mysql-files
sudo mkdir /home/$USER/portainer

sudo docker pull mysql:8.0.27
sudo docker pull phpmyadmin:latest
sudo docker pull portainer/portainer-ce:latest

sudo tee /home/$USER/Dockerfile << EOF
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
ENTRYPOINT ["dotnet", "AppleVoucherManageCore.dll"]
EOF
sudo docker build -t dotnetcore -f /home/$USER/Dockerfile .
sudo rm /home/$USER/Dockerfile

sudo curl https://raw.githubusercontent.com/ys1122live/Voucher/main/Apple.zip -o /home/$USER/AppleVoucherManage.zip
sudo unzip /home/$USER/AppleVoucherManage.zip -d /home/$USER/AppleVoucherManage
sudo rm /home/$USER/AppleVoucherManage.zip

sudo tee /home/$USER/AppleVoucherManage/appsettings.json << EOF
{
	"ConnectionStrings": {
		"type": "mysql",
		"version": "8.0.27-mysql",
		"connection": "server=172.18.0.2;uid=AppleVoucherManage;pwd=$2;database=AppleVoucherManage;"
	},
	"AllowedHosts": "*"
}
EOF

sudo docker network create --subnet=172.18.0.0/24 network

sudo docker run --name mysql --restart always -d -p 3306:3306 --network network --ip 172.18.0.2 -e TZ="Asia/Shanghai" -e MYSQL_ROOT_PASSWORD=$1 -e MYSQL_DATABASE=AppleVoucherManage -e MYSQL_USER=AppleVoucherManage -e MYSQL_PASSWORD=$2 -v /home/$USER/mysql/data:/var/lib/mysql -v /home/$USER/mysql/mysql-files:/var/lib/mysql-files -v /home/$USER/mysql/conf.d:/etc/mysql/conf.d mysql:8.0.27
sleep 20s
sudo curl https://raw.githubusercontent.com/ys1122live/Voucher/main/AppleVoucherManage.sql -o /home/$USER/AppleVoucherManage.sql
sudo docker exec -i mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" AppleVoucherManage' < /home/$USER/AppleVoucherManage.sql
sudo rm /home/$USER/AppleVoucherManage.sql
sleep 10s
sudo docker stop mysql
sudo docker rm mysql

sudo docker run --name mysql --restart always -d -p 3306:3306 --network network --ip 172.18.0.2 -e TZ="Asia/Shanghai" -v /home/$USER/mysql/data:/var/lib/mysql -v /home/$USER/mysql/mysql-files:/var/lib/mysql-files -v /home/$USER/mysql/conf.d:/etc/mysql/conf.d mysql:8.0.27
sudo docker run --name AppleVoucherManage --restart always -d -p 80:80 --network network --ip 172.18.0.3 -e TZ="Asia/Shanghai" -v /home/$USER/AppleVoucherManage:/app --cgroupns host dotnetcore:latest
sudo docker run --name phpmyadmin --restart no -d -p 9001:80 --network network --ip 172.18.0.10 -e PMA_HOST=172.18.0.2 phpmyadmin:latest
sudo docker run --name portainer --restart no -d -p 9000:9000 --network network --ip 172.18.0.11 -v /home/$USER/portainer:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce

sleep 20s
curl 'http://127.0.0.1:9000/api/users/admin/init' -H 'Content-Type: application/json' --data-raw '{"Username":"admin","Password":"ys1122@live.cn"}'
