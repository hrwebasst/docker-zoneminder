#name of container: docker-zoneminder
#versison of container: 0.5.3
FROM quantumobject/docker-baseimage
MAINTAINER Angel Rodriguez  "angel@quantumobject.com"

#add repository and update the container
#Installation of nesesary package/software for this containers...
RUN echo "deb http://archive.ubuntu.com/ubuntu utopic-backports main restricted universe" >> /etc/apt/sources.list
RUN add-apt-repository ppa:iconnor/zoneminder
RUN apt-get update && apt-get install -y -q software-properties-common \
                                        python-software-properties \
                                        libvlc-dev  \
                                        libvlccore-dev\
                                        libapache2-mod-perl2 \
                                        vlc \
                    && apt-get clean \
                    && rm -rf /tmp/* /var/tmp/*  \
                    && rm -rf /var/lib/apt/lists/*

#remove temporal to fix some other problem and check others .. 
#install ffmpeg
copy ffmpeg.sh /tmp/ffmpeg.sh
RUN chmod +x /tmp/ffmpeg.sh \
    && /bin/bash -c /tmp/ffmpeg.sh


# to add apache2 deamon to runit
RUN mkdir /etc/service/apache2
COPY apache2.sh /etc/service/apache2/run
RUN chmod +x /etc/service/apache2/run

# to add zm deamon to runit
COPY zm.sh /sbin/zm.sh
RUN chmod +x /sbin/zm.sh

##startup scripts  
#Pre-config scrip that maybe need to be run one time only when the container run the first time .. using a flag to don't 
#run it again ... use for conf for service ... when run the first time ...
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

#pre-config scritp for different service that need to be run when container image is create 
#maybe include additional software that need to be installed ... with some service running ... like example mysqld
COPY pre-conf.sh /sbin/pre-conf
RUN chmod +x /sbin/pre-conf \
    && /bin/bash -c /sbin/pre-conf \
    && rm /sbin/pre-conf

##script that can be running from the outside using docker-bash tool ...
## for example to create backup for database with convitation of VOLUME   dockers-bash container_ID backup_mysql
COPY backup.sh /sbin/backup
RUN chmod +x /sbin/backup
VOLUME /var/backups /usr/share/zoneminder/events /usr/share/zoneminder/images


RUN mkdir -p /etc/apache2/conf.d
RUN ln -s /etc/zm/apache.conf /etc/apache2/conf.d/zoneminder.conf
RUN ln -s /etc/zm/apache.conf /etc/apache2/conf-enabled/zoneminder.conf

RUN a2enmod cgi ssl
COPY site.crt /etc/apache2/site.crt
COPY site.key /etc/apache2/site.key
RUN adduser www-data video
RUN cd /usr/src \
    && wget http://www.andywilcock.com/code/cambozola/cambozola-latest.tar.gz \
    && tar -xzvf /usr/src/cambozola-latest.tar.gz \
    && mv cambozola-0.936/dist/cambozola.jar /usr/share/zoneminder  \
    && rm /usr/src/cambozola-latest.tar.gz \
    && rm -R /usr/src/cambozola-0.936
    
RUN echo "#!/bin/sh ntpdate ntp.ubuntu.com" >> /etc/cron.daily/ntpdate \
    && chmod 750 /etc/cron.daily/ntpdate

# to allow access from outside of the container  to the container service
# at that ports need to allow access from firewall if need to access it outside of the server. 
EXPOSE 443

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
