# Use an official Python runtime as a base image
FROM python:3.6-slim-stretch 

ENV NODE_VERSION 9.11.1
ENV YARN_VERSION 1.5.1
LABEL project="invgen"
ENV SSH_PASSWD "root:Docker!"

#RUN echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node \
  && apt-get update && apt-get install -y gpg dirmngr curl --no-install-recommends \
#    && rm -rf /var/lib/apt/lists/* 
# gpg keys listed at https://github.com/nodejs/node#release-team
  && set -ex \
  && for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
    77984A986EBC2AA786BC0F66B01FBB92821C587A \
  ; do \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
#
#
    && buildDeps='xz-utils' \
    && ARCH= && dpkgArch="$(dpkg --print-architecture)" \
    && case "${dpkgArch##*-}" in \
      amd64) ARCH='x64';; \
      ppc64el) ARCH='ppc64le';; \
      s390x) ARCH='s390x';; \
      arm64) ARCH='arm64';; \
      armhf) ARCH='armv7l';; \
      i386) ARCH='x86';; \
      *) echo "unsupported architecture"; exit 1 ;; \
    esac \
    && set -x \
#    && apt-get update 
    && apt-get install -y $buildDeps --no-install-recommends \
#    && rm -rf /var/lib/apt/lists/* \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
    && curl -SLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
    && apt-get purge -y --auto-remove $buildDeps \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && set -ex \
    && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
    ; do \
       gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
       gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
       gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
    done \
    && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
    && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
    && mkdir -p /opt \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
# and adding required packages 
#    && apt-get update 
    && apt-get install -y --no-install-recommends \
      dialog \
      openssh-server \
	  make \
      git \
    && echo "$SSH_PASSWD" | chpasswd \
    && git clone https://8c27f4108ac53546e205d396e86dd25cce7016a8:x-oauth-basic@github.com/UCSD-PL/inv-gen-game.git /app \
    && npm install  --silent --save-dev -g \
        gulp-cli \
        typescript \
    && rm -rf /var/lib/apt/lists/* 


COPY sshd_config /etc/ssh/
COPY init.sh /app

# Set the working directory to /app
WORKDIR /app

LABEL version="v0.1.7"

RUN git pull \
    && buildDeps="xz-utils \
                  dpkg-dev \
                  gcc \
                  build-essential" \
    && ARCH= && dpkgArch="$(dpkg --print-architecture)" \
    && case "${dpkgArch##*-}" in \
      amd64) ARCH='x64';; \
      ppc64el) ARCH='ppc64le';; \
      s390x) ARCH='s390x';; \
      arm64) ARCH='arm64';; \
      armhf) ARCH='armv7l';; \
      i386) ARCH='x86';; \
      *) echo "unsupported architecture"; exit 1 ;; \
    esac \
    && set -x \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y $buildDeps libc6 libgcc1 libstdc++6 libgomp1 --no-install-recommends \
    && chmod u+x /app/init.sh \ 
    && bash ./setupServer.sh \
    && apt-get purge -y --auto-remove $buildDeps \
    && rm -rf /var/lib/apt/lists/* 

ENV SQL_CONNECTION "mmenarini%40invgame:sdljsd%24903@invgame.mysql.database.azure.com/game"
ENV LEVEL_SET "../lvlsets/unsolved-leftover-split.lvlset"


EXPOSE 8000 2222

WORKDIR /app/src
# Run app.py when the container launches
ENTRYPOINT ["/app/init.sh"]
