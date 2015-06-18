# docker-zoneminder

Docker container for [zoneminder v1.28.1][3]

"ZoneMinder the top Linux video camera security and surveillance solution. ZoneMinder is intended for use in single or multi-camera video security applications, including commercial or home CCTV, theft prevention and child, family member or home monitoring and other domestic care scenarios such as nanny cam installations. It supports capture, analysis, recording, and monitoring of video data coming from one or more video or network cameras attached to a Linux system. ZoneMinder also support web and semi-automatic control of Pan/Tilt/Zoom cameras using a variety of protocols. It is suitable for use as a DIY home video security system and for commercial or professional video security and surveillance. It can also be integrated into a home automation system via X.10 or other protocols. If you're looking for a low cost CCTV system or a more flexible alternative to cheap DVR systems then why not give ZoneMinder a try?"

## Install dependencies

  - [Docker][2]

To install docker in Ubuntu 12.04+ use the commands:

    sudo apt-get update sudo && apt-get install -y aufs-tools apparmor && wget -qO- https://get.docker.com/ | sh

I also recommend adding yourself to the docker group so that you don't have to type sudo all the flipping time:

    sudo usermod -aG docker YOURUSERNAME

## Usage

If you're lazy and don't want to build it yourself just run this and throw a party on camera:

    $ docker run -d -e MYSQL_ROOT_PASSWORD=uberpass -e MYSQL_DATABASE=zm -e MYSQL_USER=zm -e MYSQL_PASSWORD=my-secret-pass --name=zm-mysql mysql
    $ docker run -d --name=zoneminder --link=zm-mysql:mysql -p 443:443 --privileged=true hrwebasst/docker-zoneminder

(NOTE that we don't pass any mysql parameters to postgres aside from the link. This will pass the proper env vars to zoneminder ;) )

### MISC

    There is an issue with shared memory in zoneminder with adding cameras. When you add one part of the 64M of shared memory gets used. You can see this with a simple df -h inside the container.

    In order to fix this we run the docker in privileged mode and on startup it runs the following:
    umount /dev/shm

 mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=${MEM:-2048M} tmpfs /dev/shm

    if you'd like to change the amount of memory shared for camera usage then pass in the MEM environment variable when you run the host.

    This container does not host a database and must be connected to an external MYSQL server. Mysql recently became incompatible with zoneminder and I had to add the following to modify strict mode:
    SET @@global.sql_mode= '';

### Recommended

   volumes for each container:
   mysql: /var/lib/mysql 
   Zoneminder: /var/backups /usr/share/zoneminder/events /usr/share/zoneminder/images
   
   this way you can map all of your folders outside of the containers in case you need to dump a container and rebuild it.


## Accessing the Zoneminder applications:

After that check with your browser at addresses plus the port assigined by docker:

  - **https://host_ip/zm**


note: ffmpeg was added and path for it is /usr/local/bin/ffmpeg  if needed for configuration at options .

## More Info

About zoneminder [www.zoneminder.com][1]

Original basis for this [quantumobject/docker-zoneminder][5]

[1]:http://www.zoneminder.com/
[2]:https://www.docker.com
[3]:http://www.zoneminder.com/downloads
[4]:http://docs.docker.com
[5]:https://github.com/QuantumObject/docker-zoneminder
[6]:http://www.zoneminder.com/wiki/index.php/Documentation
