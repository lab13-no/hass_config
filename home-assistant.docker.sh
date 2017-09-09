#!/bin/bash

typeset -r opt="$1"
set -e
set -u

cd `dirname $0`

typeset -r img_name="homeassistant/home-assistant"
typeset -r container_name="hass.container"
typeset -r config_export="${PWD}/"

function create() {
	mkdir -p "${config_export}"
	docker images |grep -w "${img_name}" && return 0
	echo "[INFO] creating image and container"
	typeset -r time="-v /etc/localtime:/etc/localtime:ro"
	p="${time}"
	p+=" -v ${config_export}:/config"
	docker create ${p} --name="${container_name}" --net=host "${img_name}"
}

function stop_it() {
	docker ps |grep -w "${container_name}" || return 0
	echo "[INFO] stopping container"
	docker stop "${container_name}"
}

function start_it() {
	echo "[INFO] starting container"
	docker start -a "${container_name}"
}

case "${opt}" in
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
