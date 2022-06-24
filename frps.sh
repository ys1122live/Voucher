mkdir -p ~/docker

tee ~/docker/Dockerfile << EOF
FROM alpine:latest
RUN apk update
WORKDIR /app
ENTRYPOINT ["/app/frps", "-c", "frps.ini"]
EOF

docker build -t frps -f ~/docker/Dockerfile .
rm ~/docker/Dockerfile

if [ $(uname -m) = "x86_64" ]; then
    PLATFORM=amd64
fi

if [ $(uname -m) = "aarch64" ]; then
    PLATFORM=arm64
fi

FRP_VERSION=0.43.0
FILE_NAME=frp_${FRP_VERSION}_linux_${PLATFORM}

curl https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/${FILE_NAME}.tar.gz -o ~/${FILE_NAME}.tar.gz

tar -zxvf ~/${FILE_NAME}.tar.gz -C ~/
mv ~/${FILE_NAME} ~/frp

tee ~/frp/frps.ini << EOF
[common]
bind_port = 7000
EOF

docker run --name frps --restart always -d -p 7000:7000 -p 8898:8898 -e TZ="Asia/Shanghai" -v ~/frp:/app frps:latest
