sudo apt update

sudo apt upgrade -y

sudo apt install ca-certificates curl gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

mkdir /home/ubuntu/GameVoucherManageCore
mkdir /home/ubuntu/docker
mkdir /home/ubuntu/mysql
mkdir /home/ubuntu/mysql/data
mkdir /home/ubuntu/mysql/mysql-files

sudo docker pull mysql:8.0.27
sudo docker pull phpmyadmin:latest
sudo docker pull portainer/portainer-ce:latest

curl https://raw.githubusercontent.com/ys1122live/Voucher/main/Dockerfile -o /home/ubuntu/docker/Dockerfile
sudo docker build -t dotnetcore -f /home/ubuntu/docker/Dockerfile .

curl https://raw.githubusercontent.com/ys1122live/Voucher/main/GameVoucherManageCore.zip -o /home/ubuntu/GameVoucherManageCore.zip
unzip /home/ubuntu/GameVoucherManageCore.zip -d /home/ubuntu/GameVoucherManageCore
rm /home/ubuntu/GameVoucherManageCore.zip

curl https://raw.githubusercontent.com/ys1122live/Voucher/main/mysql.zip -o /home/ubuntu/mysql.zip
unzip /home/ubuntu/mysql.zip -d /home/ubuntu/mysql/data
rm /home/ubuntu/mysql.zip

sudo docker run --name mysql --restart always -d -p 3306:3306 -e TZ="Asia/Shanghai" -v /home/ubuntu/mysql/data:/var/lib/mysql -v /home/ubuntu/mysql/mysql-files:/var/lib/mysql-files -v /home/ubuntu/mysql/conf.d:/etc/mysql/conf.d mysql:8.0.27
sudo docker run --name GameVoucherManageCore --restart always -d -p 80:80 -e TZ="Asia/Shanghai" -v /home/ubuntu/GameVoucherManageCore:/app --cgroupns host dotnetcore:latest
sudo docker run --name phpmyadmin --restart no -d -e PMA_HOST=172.17.0.2 -p 9001:80 phpmyadmin:latest
sudo docker run --name portainer --restart no -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce
