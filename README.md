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

    $ docker run -d --name mysql -e MYSQL_DATABASE=zm -e MYSQL_ROOT_PASSWORD=my-secret-password mysql

    $ docker run -d --link mysql -p 443:443 --privileged=true -e DB_HOST=mysql -e DB_USER=root -e DB_NAME=zm -e DB_PASS=my-secret-password hrwebasst/docker-zoneminder

### Note

    We suggest running this with a mysql database but if you do not provide a DB_HOST variable we will assume that you want to risk losing your database if your docker host dies or leave the container.

## Accessing the Zoneminder applications:

After that check with your browser at addresses plus the port assigined by docker:

  - **https://host_ip/zm**


note: ffmpeg was added and path for it is /usr/local/bin/ffmpeg  if needed for configuration at options .

## More Info

About zoneminder [www.zoneminder.com][1]

To help improve this container [quantumobject/docker-zoneminder][5]

[1]:http://www.zoneminder.com/
[2]:https://www.docker.com
[3]:http://www.zoneminder.com/downloads
[4]:http://docs.docker.com
[5]:https://github.com/QuantumObject/docker-zoneminder
[6]:http://www.zoneminder.com/wiki/index.php/Documentation
