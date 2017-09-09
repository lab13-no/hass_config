#!/bin/bash

set -e
set -u

cd `dirname $0`

typeset -r -i use_x11=0
if [ $use_x11 -gt 0 ]; then
	xhost |grep ^LOCAL || xhost local:root

	# on Fedora, we might also need to disable SELinux
	#setenforce 0
	# or at least allow docker to talk with X
	# by adjusting the appropriate SELinux policy
fi

typeset -r img_name="homeassistant/home-assistant"
typeset -r container_name="hass.container"
typeset -r img="${img_name}"
typeset -r cnt="${container_name}"
typeset -r config_export="${PWD}/"

function create() {
	mkdir -p "${config_export}"
	docker images |grep -w "${img}" && return 0
	echo "[INFO] creating image and container"
	typeset -r x11="-v /tmp/.X11-unix/X0:/tmp.X11-unix -e DISPLAY=unix$DISPLAY"
	typeset -r time="-v /etc/localtime:/etc/localtime:ro"
	p="${time}"
	p+=" -v ${config_export}:/config"
	[[ ${use_x11} -gt 0 ]] && p+=" ${x11}"
	docker create ${p} --name="${cnt}" --net=host "${img}"
}

function stop_it() {
	docker ps |grep -w "${cnt}" || return 0
	echo "[INFO] stopping container"
	docker stop "${cnt}"
}

function start_it() {
	echo "[INFO] starting container"
	docker start -a "${cnt}"
}

case "$1" in
create)
	create
	;;
start)
	create
	stop_it
	start_it
	;;
stop)
	stop_it
	;;
*)
	echo "You need to specify either start or stop"
	;;
esac
