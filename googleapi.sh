if [ -z "$1" ] ;then
	echo "database ip empty"
	exit
fi

if [ -z "$2" ] ;then
	echo "database pass empty"
	exit
fi

sudo apt update

sudo apt upgrade -y

sudo apt install ca-certificates curl gnupg lsb-release unzip -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y


mkdir ~/GameVoucherApi
mkdir ~/portainer

sudo docker pull portainer/portainer-ce:latest
sudo docker pull mcr.microsoft.com/dotnet/aspnet:6.0

curl https://raw.githubusercontent.com/ys1122live/Voucher/main/GameVoucherApi.zip -o ~/GameVoucherApi.zip
unzip ~/GameVoucherApi.zip -d ~/GameVoucherApi
chmod +x ~/GameVoucherApi/GameVoucherApiCore
rm ~/GameVoucherApi.zip

tee ~/GameVoucherApi/appsettings.json << EOF
{
	"ConnectionStrings": {
		"version": "8.0.27-mysql",
		"connection": "server=$1;uid=GameVoucherManage;pwd=$2;database=GameVoucherManage;"
	},
	"AllowedHosts": "*"
}
EOF

sudo docker network create --subnet=172.18.0.0/24 network
sudo docker run --name GameVoucherApi --restart always -d -p 80:80 --network network --ip 172.18.0.3 -e TZ="Asia/Shanghai" -v ~/GameVoucherApi:/app -w /app --cgroupns host mcr.microsoft.com/dotnet/aspnet:6.0 ./GameVoucherApiCore
sudo docker run --name portainer --restart no -d -p 9000:9000 --network network --ip 172.18.0.11 -v ~/portainer:/data -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce
