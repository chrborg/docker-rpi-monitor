# About this Repo

This is a forked Git repo from [rpi-monitor](https://github.com/michaelmiklis/docker-rpi-monitor), which adds monitoring capabilities of embedded devices which are not configured by default example: USB Hard Drive.

The Docker image is available at [rpi-monitor](https://hub.docker.com/r/chrborg/rpi-monitor/). See [the Docker Hub page](https://hub.docker.com/r/chrborg/rpi-monitor/) for the full readme on how to use this Docker image and for information regarding contributing and issues.

docker-rpi-monitor
========
RPi-Monitor from [RPi-Experiences](http://rpi-experiences.blogspot.de/p/rpi-monitor.html) is an easy and free to use WebUI to monitor your Raspberry PI.

To run the docker-rpi-monitor image and monitor your physical Raspberry PI instead of the docker container itself, a lot of volumes needs to be mapped into the container:

	/opt/vc
	/boot
	/sys	
	/etc	
	/proc	
	/usr/lib

All volumes are mapped as read-only to ensure the container can't modify the data on the docker host. Additionally access to the Raspberry PI's vchiq and vcsm device needs to be mapped to the container to access hardware sensors, like CPU Temperature, e.g.

Additional Device Monitoring:
------------------------------
By default, the docker-rpi-monitor image is built and configured to monitor the USB drive at /dev/sda1. Any additional devices can be added by adding a configuration file under templates directory(similar to usb_hdd.conf) and then the image has to be built again.

It is important that the device mounting location is mapped into the container ex: /mnt/hdd. Additionally access to the device needs to be mapped as well to the container ex: /dev/sda1

Quickstart
----------
	docker run --device=/dev/vchiq --device=/dev/vcsm --device=/dev/sda1 --volume=/opt/vc:/opt/vc --volume=/boot:/boot --volume=/sys:/dockerhost/sys:ro --volume=/etc:/dockerhost/etc:ro --volume=/proc:/dockerhost/proc:ro --volume=/usr/lib:/dockerhost/usr/lib:ro --volume=/mnt/hdd:/mnt/hdd:ro -p=8888:8888 --name="rpi-monitor" -d  chrborg/rpi-monitor:latest
	
Start Container Using `docker-compose`
----------
`docker-compose up -d`

Access
----------
After a successful start you can access the RPi-Monitor using http://dockerhost-ip:8888
