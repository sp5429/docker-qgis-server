FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
COPY ./msyh  /usr/share/fonts/
COPY ./sources.list /etc/apt/
RUN apt update \ 
  && apt install --no-install-recommends --no-install-suggests --allow-unauthenticated -y \
  apache2
COPY ./ports.conf /etc/apache2/
COPY ./qgis-server.conf /etc/apache2/sites-available/
COPY ./apache2-foreground /usr/bin/apache2-foreground
RUN chmod 777 /usr/bin/apache2-foreground \
  && apt update \
  && apt install --no-install-recommends --no-install-suggests --allow-unauthenticated -y \
  software-properties-common \
  gnupg \
  wget \
  && mkdir -m755 -p /etc/apt/keyrings \
  && wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/qgis-archive-keyring.gpg] https://qgis.org/ubuntu-ltr bionic main" | tee /etc/apt/sources.list.d/qgis.list \
  && apt-get update \
  && apt install --no-install-recommends --no-install-suggests --allow-unauthenticated -y \
  libapache2-mod-fcgid \
  qgis-server \
  && a2enmod headers && a2enmod fcgid && cd /etc/apache2/sites-available/ && a2ensite qgis-server \
  && fc-cache -fv 
CMD apache2-foreground