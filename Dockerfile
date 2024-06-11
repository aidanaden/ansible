#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM amd64/ubuntu:22.04

# RUN --mount=type=bind,src="$PWD",target=~/Projects/ansible  
COPY . /root


RUN --mount=type=cache,target=/var/cache/apt \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list 

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
    && DEBIAN_FRONTEND="noninteractive" apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get -y upgrade \
    && DEBIAN_FRONTEND="noninteractive" apt-get -y --no-install-recommends install curl git man unzip wget gpg gpg-agent software-properties-common \
    && DEBIAN_FRONTEND="noninteractive" add-apt-repository --yes --update ppa:ansible/ansible \
    && DEBIAN_FRONTEND="noninteractive" apt-get -y --no-install-recommends install ansible

RUN rm -rf /var/lib/apt/lists/*

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["bash"]
