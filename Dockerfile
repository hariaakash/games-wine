# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: FOR WINDOWS GAMES
# ----------------------------------
FROM suchja/x11client:latest

MAINTAINER Pterodactyl Software, <support@pterodactyl.io>

# Inspired by monokrome/wine
ENV WINE_MONO_VERSION 0.0.8
USER root

# Install some tools required for creating the image
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		curl \
		unzip \
		wget \
		ca-certificates \
	&& useradd -m -d /home/container container

# Install wine and related packages
RUN dpkg --add-architecture i386 \
		&& apt-get update \
		&& apt-get install -y --no-install-recommends \
				wine \
				wine32 \
		&& rm -rf /var/lib/apt/lists/*

# Use the latest version of winetricks
RUN curl -SL 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks' -o /usr/local/bin/winetricks \
		&& chmod +x /usr/local/bin/winetricks

# Get latest version of mono for wine
RUN mkdir -p /usr/share/wine/mono \
	&& curl -SL 'http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download' -o /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi \
	&& chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi
	

USER container
ENV  USER container
ENV  HOME /home/container
ENV WINEPREFIX /home/container/.wine
ENV WINEARCH win32

RUN cd /home/container \
	&& wget -O halo.zip https://www.dropbox.com/s/4c2r4812cx0qf1h/halo.zip?dl=1 \
	&& unzip halo.zip \
	&& rm halo.zip

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]