# Use an official Python runtime as a base image
FROM ubuntu:16.04

LABEL project="inv-gen-game-small"


ENV SSH_PASSWD "root:Docker!"

# and adding required packages 
RUN apt-get update && apt-get install -y --no-install-recommends \
  dialog \
  openssh-server \
  git \
  software-properties-common \
  python3 \
  python3-dev \
  python3-pip \
  python3-venv \
  build-essential \
  mono-devel \
  mono-xbuild \
  nodejs-legacy \
  npm \
 && rm -rf /var/lib/apt/lists/* \
 && echo "$SSH_PASSWD" | chpasswd \
 && git clone -b dockerized https://8c27f4108ac53546e205d396e86dd25cce7016a8:x-oauth-basic@github.com/UCSD-PL/inv-gen-game.git /app \
 && npm install -g gulp-cli \
 && npm install -g --save-dev typescript gulp gulp-typescript \
 && npm install -g --save-dev browserify tsify vinyl-source-stream \
 && npm install -g --save-dev watchify gulp-util \
 && npm install -g --save-dev gulp-uglify vinyl-buffer gulp-sourcemaps \
 && npm install -g tsc \
 && npm install -g typings \
 && npm install -g typescript \
 && npm install -g jquery --save \
 && npm install -g @types/jquery --save \
 && npm install -g --save @types/jquery-jsonrpcclient \
 && pip3 install wheel \
 && pip3 install setuptools 

COPY sshd_config /etc/ssh/

# Set the working directory to /app
WORKDIR /app


LABEL version="v0.0.1-beta"

COPY built_env.tgz /app/

RUN git pull \
  && cp /app/init.sh /usr/local/bin/ \
  && chmod u+x /usr/local/bin/init.sh \ 
  && tar zxf built_env.tgz \ 
  && bash ./setupServer.sh


ENV SQL_CONNECTION "mmenarini%40invgame:sdljsd%24903@invgame.mysql.database.azure.com/game"
ENV ADMIN_TOKEN "fuzzy"
ENV LEVEL_SET "../lvlsets/unsolved-leftover-split.lvlset"


EXPOSE 8000 2222

WORKDIR /app/src
# Run app.py when the container launches
ENTRYPOINT ["init.sh"]
