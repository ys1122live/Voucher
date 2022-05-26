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

sudo mkdir /mnt/AppleVoucherManage
sudo mkdir /mnt/docker
sudo mkdir /mnt/mysql
sudo mkdir /mnt/mysql/data
sudo mkdir /mnt/mysql/mysql-files
sudo mkdir /mnt/portainer

sudo docker pull mysql:8.0.27
sudo docker pull phpmyadmin:latest
sudo docker pull portainer/portainer-ce:latest

sudo curl https://raw.githubusercontent.com/ys1122live/Voucher/main/Dockerfile -o /mnt/docker/Dockerfile
sudo docker build -t dotnetcore -f /mnt/docker/Dockerfile .

sudo curl https://raw.githubusercontent.com/ys1122live/Voucher/main/portainer.zip -o /mnt/portainer.zip
sudo unzip /mnt/portainer.zip -d /mnt/portainer
sudo rm /mnt/portainer.zip

sudo curl https://raw.githubusercontent.com/ys1122live/Voucher/main/Apple.zip -o /mnt/AppleVoucherManage.zip
sudo unzip /mnt/AppleVoucherManage.zip -d /mnt/AppleVoucherManage
sudo rm /mnt/AppleVoucherManage.zip

sudo tee /mnt/AppleVoucherManage/appsettings.json << EOF
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

sudo docker run --name mysql --restart always -d -p 3306:3306 --network network --ip 172.18.0.2 -e TZ="Asia/Shanghai" -e MYSQL_ROOT_PASSWORD=$1 -e MYSQL_DATABASE=AppleVoucherManage -e MYSQL_USER=AppleVoucherManage -e MYSQL_PASSWORD=$2 -v /mnt/mysql/data:/var/lib/mysql -v /mnt/mysql/mysql-files:/var/lib/mysql-files -v /mnt/mysql/conf.d:/etc/mysql/conf.d mysql:8.0.27
sleep 20s
sudo curl https://raw.githubusercontent.com/ys1122live/Voucher/main/AppleVoucherManage.sql -o /mnt/AppleVoucherManage.sql
sudo docker exec -i mysql sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" AppleVoucherManage' < /mnt/AppleVoucherManage.sql
sudo rm /mnt/AppleVoucherManage.sql
sleep 10s
sudo docker stop mysql
sudo docker rm mysql

sudo docker run --name mysql --restart always -d -p 3306:3306 --network network --ip 172.18.0.2 -e TZ="Asia/Shanghai" -v /mnt/mysql/data:/var/lib/mysql -v /mnt/mysql/mysql-files:/var/lib/mysql-files -v /mnt/mysql/conf.d:/etc/mysql/conf.d mysql:8.0.27
sudo docker run --name AppleVoucherManage --restart always -d -p 80:80 --network network --ip 172.18.0.3 -e TZ="Asia/Shanghai" -v /mnt/AppleVoucherManage:/app --cgroupns host dotnetcore:latest
sudo docker run --name phpmyadmin --restart no -d -p 9001:80 --network network --ip 172.18.0.10 -e PMA_HOST=172.18.0.2 phpmyadmin:latest
sudo docker run --name portainer --restart no -d -p 9000:9000 --network network --ip 172.18.0.11 -v /mnt/portainer:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce