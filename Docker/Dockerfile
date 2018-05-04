# Use an official Python runtime as a base image
FROM ubuntu:16.04

LABEL version="0.0.2-beta"
LABEL project="inv-gen-game"


ENV SSH_PASSWD "root:Docker!"

# and adding required packages 
RUN apt-get update && apt-get install -y --no-install-recommends \
  dialog \
  openssh-server \
  git \
  software-properties-common \
  wget \
  zip \
  python3 \
  python3-dev \
  python3-pip \
  python3-venv \
  build-essential \
  mono-devel \
  mono-xbuild \
  nodejs-legacy \
  npm \
  libssl-dev \
  libffi-dev \
  libmysqlclient-dev \
  openjdk-8-jdk \
 && rm -rf /var/lib/apt/lists/* \
 && echo "$SSH_PASSWD" | chpasswd \
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
 && npm install -g --save @types/jquery-jsonrpcclient


# Downloading the latest version of the app
RUN  git clone -b dockerized https://8c27f4108ac53546e205d396e86dd25cce7016a8:x-oauth-basic@github.com/UCSD-PL/inv-gen-game.git /app

# Set the working directory to /app
WORKDIR /app

RUN cp /app/sshd_config /etc/ssh/ \
  && cp /app/init.sh /usr/local/bin/ \
  && chmod u+x /usr/local/bin/init.sh
 
# Install any needed packages specified in requirements.txt
RUN pip3 install wheel \
 && pip3 install -r requirements.txt \
 && bash ./setupServer.sh

ENV SQL_CONNECTION "gamification:m58xXuH5VBuWXtaW@gamificationfacebook.cpepc4fuqyhq.us-west-2.rds.amazonaws.com/game"
ENV ADMIN_TOKEN "fuzzy"
ENV LEVEL_SET "../lvlsets/unsolved-leftover-split.lvlset"


EXPOSE 8000 2222

WORKDIR /app/src
# Run app.py when the container launches
ENTRYPOINT ["init.sh"]
