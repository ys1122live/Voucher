mkdir -p ~/docker/build

tee ~/docker/build/Dockerfile << EOF
FROM alpine:latest
RUN apk update
WORKDIR /app
ENTRYPOINT ["/app/frpc", "-c", "frpc.ini"]
EOF

docker build -t frpc -f ~/docker/build/Dockerfile .
rm ~/docker/build/Dockerfile

if [ $(uname -m) = "x86_64" ]; then
    PLATFORM=amd64
fi

if [ $(uname -m) = "aarch64" ]; then
    PLATFORM=arm64
fi

FRP_VERSION=0.43.0
FILE_NAME=frp_${FRP_VERSION}_linux_${PLATFORM}

wget -P https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/FILE_NAME.tar.gz -O ~/docker/${FILE_NAME}.tar.gz

tar -zxvf ~/docker/${FILE_NAME}.tar.gz -C ~/docker
mv ~/docker/${FILE_NAME} ~/docker/frp

tee ~/docker/frp/frpc.ini << EOF
[common]
server_addr = 111.224.193.26
server_port = 7000

[api]
type = tcp
local_ip = 172.18.0.3
local_port = 80
remote_port = 8898
EOF

docker run --name frpc --restart always -d --network network --ip 172.18.0.20 -e TZ="Asia/Shanghai" -v ~/docker/frp:/app frpc:latest
