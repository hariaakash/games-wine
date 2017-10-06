# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: FOR WINDOWS GAMES
# ----------------------------------
FROM ubuntu:16.04

MAINTAINER Hari Narayanan, <smgdark@gmail.com>

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		curl \
		tar \
	&& useradd -m -d /home/container container

RUN dpkg --add-architecture i386

RUN apt-get update -y
RUN apt-get install -y software-properties-common && add-apt-repository -y ppa:ubuntu-wine/ppa
RUN apt-get update -y

RUN apt-get install -y wine1.7 winetricks

RUN apt-get purge -y software-properties-common
RUN apt-get autoclean -y
				
USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]