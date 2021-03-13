FROM debian:latest

ARG lua_version=5.3.6
ARG luarocks_version=3.5.0
ARG install_location=/app/install

# Export paths to directories so lua knows where to find custom modules for loading
ENV LUA_PATH_5_3=;/app/src/coding_questions/data_structures/?.lua;/app/src/coding_questions/data_structures/graphs/?.lua;;
RUN export LUA_PATH_5_3

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
