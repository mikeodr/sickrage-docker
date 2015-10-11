FROM phusion/baseimage:0.9.17
MAINTAINER Specter <mike@mikeodriscoll.ca>
ENV DEBIAN_FRONTEND noninteractive

# Set correct environment variables
ENV HOME /root

CMD ["/sbin/my_init"]

RUN usermod -u 99 nobody
RUN usermod -g 100 nobody

RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse"
RUN add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse"
RUN apt-get update -qq
RUN apt-get upgrade -qq

# Install Dependencies
RUN apt-get install -qq -y git python python-cheetah ca-certificates wget unrar unzip

# Install SickRage
RUN mkdir /opt/sickrage
RUN git clone https://github.com/SiCKRAGETV/SickRage.git -b master /opt/sickrage
RUN chown -R nobody:users /opt/sickrage

EXPOSE 8081

# SickRage Configuration
VOLUME /config

# Downloads directory
VOLUME /downloads

# TV directory
VOLUME /tv

# Add SickRage to runit
RUN mkdir /etc/service/sickrage
ADD init/sickrage.sh /etc/service/sickrage/run
RUN chmod +x /etc/service/sickrage/run
