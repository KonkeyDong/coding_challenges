FROM debian:latest

ENV lua_version 5.3.6
ENV luarocks_version 3.5.0
ENV install_location /app/install

RUN apt update --yes && \
    apt upgrade --yes && \
    apt install --yes \
        vim \
        wget \
        curl \
        build-essential \
        libreadline-dev \
        libssl-dev \
        zip \
        git

WORKDIR /app
RUN mkdir -p ${install_location}
COPY . /app

# install Lua 5.3.6
RUN wget http://www.lua.org/ftp/lua-${lua_version}.tar.gz -P ${install_location} && \
    cd ${install_location} && \
    tar xf lua-${lua_version}.tar.gz && \
    cd lua-${lua_version} && \
    make linux && \
    ln -s ${install_location}/lua-${lua_version}/src/lua /usr/bin/lua

# install luarocks 3.5.0
RUN wget https://luarocks.org/releases/luarocks-${luarocks_version}.tar.gz -P ${install_location} && \
    cd ${install_location} && \
    tar zxpf luarocks-${luarocks_version}.tar.gz && \
    cd luarocks-${luarocks_version} && \
    ./configure --with-lua-include=${install_location}/lua-${lua_version}/src/ && make bootstrap

# install useful lua modules
RUN luarocks install debugger && \
    luarocks install ldoc && \
    luarocks install luafilesystem && \
    luarocks install penlight && \
    luarocks install busted
