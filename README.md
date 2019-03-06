# nginx-gcloud-storage
proxy server for GKE Storage 

## Installation
```
$ prepare.sh
```

## Prerequisite
- luacrypto
- luasec
- luasocket

Please run this after you run prepare.sh

for Linux
```
$ sudo luarocks install luacrypto
$ sudo luarocks install luasec
$ sudo luarocks install luasocket
```

for OSX
```
$ sudo luarocks install luacrypto OPENSSL_DIR=/usr/local/opt/openssl
$ sudo luarocks install luasec OPENSSL_DIR=/usr/local/opt/openssl
$ sudo luarocks install luasocket
```

## How to run
```
$ openresty -p `pwd`/ -c conf/nginx.conf
```
