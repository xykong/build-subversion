FROM ubuntu:focal

LABEL maintainer="xy.kong@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Asia/Shanghai

RUN apt update && \
    apt -y install build-essential libxml2 libxml2-dev libxslt1-dev \
    openssl libssl-dev libsasl2-2 libsasl2-dev libboost-all-dev python \
    autoconf libtool libtool-bin vim wget unzip

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
    -t robbyrussell

WORKDIR /root
RUN wget https://ftp.kddi-research.jp/infosystems/apache/subversion/subversion-1.14.1.tar.bz2
RUN tar -xf subversion-1.14.1.tar.bz2

WORKDIR /root/subversion-1.14.1

RUN ./get-deps.sh apr serf zlib sqlite

RUN cd apr/; ./buildconf; ./configure; touch libtoolT; make; make install; cd ..
RUN cd apr-util; ./buildconf; ./configure --with-apr=/usr/local/apr/bin/; make; make install; cd ..
RUN cd apr-util/xml/expat/; ./buildconf.sh; ./configure; make install; cd ../../..
RUN cd zlib/; ./configure; make; make install; cd ..

RUN ./autogen.sh; ./configure --with-lz4=internal --with-utf8proc=internal --enable-plaintext-password-storage; make; make install
RUN ldconfig -v
RUN svn --version
