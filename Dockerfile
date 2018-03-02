# Use an official Python runtime as a base image
FROM ubuntu:17.04

LABEL version="0.0.1-beta"
LABEL project="inv-gen-game"


# Adding apt repository for Oracle Java
# and adding required packages 
RUN apt-get update && apt-get install -y \
  git \
  software-properties-common \
  wget \
  zip \
  python2.7 \
  python2.7-dev \
  python-pip \
  build-essential \
  mono-devel \
  mono-xbuild \
  nodejs-legacy \
  npm \
  libssl-dev \
  libffi-dev \
  libmysqlclient-dev\
  openjdk-8-jdk\
 && rm -rf /var/lib/apt/lists/*

# Downloading the latest version of the app
RUN  git clone https://8c27f4108ac53546e205d396e86dd25cce7016a8:x-oauth-basic@github.com/UCSD-PL/inv-gen-game.git /app

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app
 
# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt && \
	./install-verification-tools.sh

CMD ["/bin/bash"]

# Make port 80 available to the world outside this container
#EXPOSE 80

# Define environment variable
#ENV NAME World

# Run app.py when the container launches
#CMD ["python", "app.py"]
