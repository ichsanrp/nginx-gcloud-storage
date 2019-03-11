#!/bin/bash

#check & install dependency
if hash unzip 2>/dev/null; then
    if [[ "$OSTYPE" == "linux"* ]]; then
        sudo apt-get install unzip
    fi
fi

if hash make 2>/dev/null; then
    if [[ "$OSTYPE" == "linux"* ]]; then
        sudo apt-get install make
    fi    
fi

function install_openresty(){
    if [[ "$OSTYPE" == "linux"* ]]; then
        wget -qO - https://openresty.org/package/pubkey.gpg | sudo apt-key add -
        sudo apt-get -y install software-properties-common
        sudo add-apt-repository -y "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main"
        sudo apt-get update
        sudo apt-get install openresty
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew tap openresty/brew
        brew install openresty
    fi
}

function install_luarocks(){
    curl -L http://luarocks.org/releases/luarocks-3.0.4.tar.gz -o luarocks-3.0.4.tar.gz
    tar -xzvf luarocks-3.0.4.tar.gz
    cd luarocks-3.0.4/
    if [[ "$OSTYPE" == "linux"* ]]; then
        ./configure --prefix=/usr/local/openresty/ \
        --rocks-tree=/usr/local/ \
        --with-lua=/usr/local/openresty/luajit/ \
        --with-lua-bin=/usr/local/openresty/luajit/bin \
        --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        ./configure --prefix=/usr/local/Cellar/openresty/1.13.6.2/ \
        --rocks-tree=/usr/local/ \
        --with-lua=/usr/local/Cellar/openresty/1.13.6.2/luajit/ \
        --with-lua-bin=/usr/local/Cellar/openresty/1.13.6.2/luajit/bin \
        --with-lua-include=/usr/local/Cellar/openresty/1.13.6.2/luajit/include/luajit-2.1
    fi
    make
    sudo make install
    cd ..
    rm -rf luarocks-3.0.4
    rm luarocks-3.0.4.tar.gz
}

function prepare_project_scaffolding(){
    mkdir conf
    mkdir src
    mkdir logs
    curl https://raw.githubusercontent.com/ichsanrp/nginx-gcloud-storage/master/conf/nginx.conf -o conf/nginx.conf
    if [[ "$OSTYPE" == "linux"* ]]; then
        ln -s /usr/local/openresty/site/lualib/ src
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        ln -s /usr/local/Cellar/openresty/1.13.6.2/site/lualib/ src
    fi
}

prepare_project_scaffolding
install_openresty
install_luarocks

echo "Setup env complete ..."
echo "====="
echo "run project by 'openresty -p `pwd`/ -c conf/nginx.conf' "
echo ""
echo "Have a nice day!"